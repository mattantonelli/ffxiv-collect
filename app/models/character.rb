# == Schema Information
#
# Table name: characters
#
#  id                 :bigint(8)        not null, primary key
#  name               :string(255)      not null
#  server             :string(255)      not null
#  portrait           :string(255)      not null
#  avatar             :string(255)      not null
#  last_parsed        :datetime
#  verified_user_id   :integer
#  achievements_count :integer          default(0)
#  mounts_count       :integer          default(0)
#  minions_count      :integer          default(0)
#  orchestrions_count :integer          default(0)
#  emotes_count       :integer          default(0)
#  bardings_count     :integer          default(0)
#  hairstyles_count   :integer          default(0)
#  armoires_count     :integer          default(0)
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  public             :boolean          default(TRUE)
#  achievement_points :integer          default(0)
#  free_company_id    :string(255)
#  queued_at          :datetime         default(Thu, 01 Jan 1970 00:00:00 UTC +00:00)
#  gender             :string(255)
#  spells_count       :integer          default(0)
#

class Character < ApplicationRecord
  after_destroy :clear_user_characters
  belongs_to :verified_user, class_name: 'User', required: false
  belongs_to :free_company, required: false

  scope :recent,   -> { where('characters.updated_at > ?', Date.current - 3.months) }
  scope :verified, -> { where.not(verified_user: nil) }
  scope :visible,  -> { where(public: true) }
  scope :with_public_achievements, -> { where('achievements_count > 0') }

  CHARACTER_API_BASE = 'https://www.lalachievements.com/api/charrealtime'.freeze
  CHARACTER_PROFILE_BASE = 'https://na.finalfantasyxiv.com/lodestone/character'.freeze

  %i(achievements mounts minions orchestrions emotes bardings hairstyles armoires spells).each do |model|
    has_many "character_#{model}".to_sym, dependent: :delete_all
    has_many model, through: "character_#{model}".to_sym
  end

  def sync
    update(queued_at: Time.now)
    CharacterSyncJob.perform_later(id)
  end

  def triple_triad
    verified_user&.triple_triad
  end

  def verify!(user)
    begin
      page = Nokogiri::HTML(open("#{CHARACTER_PROFILE_BASE}/#{self.id}"))
      profile = page.css('.character__selfintroduction').text

      if profile.include?(verification_code(user))
        update!(verified_user_id: user.id)
      end
    rescue
    end
  end

  def verification_code(user)
    code = Digest::SHA2.hexdigest("#{user.id}-#{self.id}")
    "ffxivcollect:#{code}"
  end

  def verified?
    verified_user_id.present?
  end

  def verified_user?(user)
    user.present? && user.id == verified_user_id
  end

  def private?(user = nil)
    if user.present?
      !self.public && verified_user_id != user.id
    else
      !self.public
    end
  end

  def stale?
    last_parsed < Time.now - 6.hours
  end

  def in_queue?
    queued_at > Time.now - 30.minutes
  end

  def self.fetch(id)
    begin
      result = JSON.parse(RestClient.get("#{CHARACTER_API_BASE}/#{id}" \
                                         "?key=#{Rails.application.credentials.lalachievements_key}"))
      Character.update(result)
      Character.find_by(id: id)
    rescue RestClient::ExceptionWithResponse => e
      Rails.logger.error("There was a problem fetching character #{id}: #{e.response}")
      nil
    end
  end

  def self.search(server, name)
    XIVAPI_CLIENT.character_search(server: server, name: name).to_a
  end

  def self.data_centers
    servers_by_data_center.keys.sort.freeze
  end

  def self.servers
    servers_by_data_center.values.flatten.sort.freeze
  end

  def self.servers_by_data_center
    {
      "Aether" => %w(Adamantoise Cactuar Faerie Gilgamesh Jenova Midgardsormr Sargatanas Siren),
      "Chaos" => %w(Cerberus Louisoix Moogle Omega Ragnarok Spriggan),
      "Crystal" => %w(Balmung Brynhildr Coeurl Diabolos Goblin Malboro Mateus Zalera),
      "Elemental" => %w(Aegis Atomos Carbuncle Garuda Gungnir Kujata Ramuh Tonberry Typhon Unicorn),
      "Gaia" => %w(Alexander Bahamut Durandal Fenrir Ifrit Ridill Tiamat Ultima Valefor Yojimbo Zeromus),
      "Light" => %w(Lich Odin Phoenix Shiva Zodiark Twintania),
      "Mana" => %w(Anima Asura Belias Chocobo Hades Ixion Mandragora Masamune Pandaemonium Shinryu Titan),
      "Primal" => %w(Behemoth Excalibur Exodus Famfrit Hyperion Lamia Leviathan Ultros)
    }.freeze
  end

  private
  def self.update(data)
    if data['fcId'].present?
      fc = { id: data['fcId'], name: data['fcName'] }
      if existing = FreeCompany.find_by(id: fc[:id])
        existing.update!(fc)
      else
        FreeCompany.create!(fc)
      end
    end

    info = { id: data['id'], name: data['name'], server: data['worldName'], gender: data['genderName']&.downcase,
             portrait: data['imageUrl'], avatar: data['iconUrl'], free_company_id: data['fcId'],
             last_parsed: Time.at(data['updatedAt'] / 1000) }
    info[:achievements_count] = -1 if data['achievementsPrivate']

    if character = Character.find_by(id: info[:id])
      character.update(info)
    else
      character = Character.create!(info)
    end

    unless data['achievementsPrivate']
      achievement_ids = CharacterAchievement.where(character_id: character.id).pluck(:achievement_id)
      achievements = data['achievements'].reject { |achievement| achievement_ids.include?(achievement['id']) }
      Character.bulk_insert_achievements(character, achievements)
    end

    mount_ids = CharacterMount.where(character_id: character.id).pluck(:mount_id)
    Character.bulk_insert(info[:id], CharacterMount, :mount, data['mounts'].pluck('id') - mount_ids)

    minion_ids = CharacterMinion.where(character_id: character.id).pluck(:minion_id)
    Character.bulk_insert(info[:id], CharacterMinion, :minion,
                          data['minions'].pluck('id') - minion_ids - Minion.unsummonable_ids)

    true
  end

  def self.bulk_insert(character_id, model, model_name, ids)
    return unless ids.present?

    date = Time.now.to_formatted_s(:db)
    values = ids.map { |id| "(#{character_id}, #{id}, '#{date}', '#{date}')" }
    model.connection.execute("INSERT INTO #{model.table_name}(character_id, #{model_name}_id, created_at, updated_at)" \
                             " values #{values.join(',')}")
    Character.reset_counters(character_id, "#{model_name}s_count")
  end

  def self.bulk_insert_achievements(character, achievements)
    return unless achievements.present?

    values = achievements.map do |achievement|
      date = Time.at(achievement['date']).to_formatted_s(:db)
      "(#{character.id}, #{achievement['id']}, '#{date}', '#{date}')"
    end

    CharacterAchievement.connection
      .execute("INSERT INTO character_achievements(character_id, achievement_id, created_at, updated_at)" \
               " values #{values.join(',')}")

    Character.reset_counters(character.id, :achievements_count)
    character.update(achievement_points: character.achievements.sum(:points))
  end

  def clear_user_characters
    User.where(character_id: self.id).update_all(character_id: nil)
  end
end
