# == Schema Information
#
# Table name: characters
#
#  id                 :bigint(8)        not null, primary key
#  name               :string(255)      not null
#  server             :string(255)      not null
#  portrait           :string(255)      not null
#  avatar             :string(255)      not null
#  last_parsed        :datetime         not null
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
#

class Character < ApplicationRecord
  after_destroy :clear_user_characters
  belongs_to :verified_user, class_name: 'User', required: false
  belongs_to :free_company, required: false

  scope :verified, -> { where.not(verified_user: nil) }
  scope :visible, -> { where(public: true) }
  scope :with_public_achievements, -> { where('achievements_count > 0') }

  CHARACTER_COLUMNS = %w(Achievements Character.Avatar Character.ID Character.Minions Character.Mounts Character.Name
  Character.FreeCompanyId Character.ParseDate Character.Portrait Character.Server FreeCompany Info).freeze

  %i(achievements mounts minions orchestrions emotes bardings hairstyles armoires).each do |model|
    has_many "character_#{model}".to_sym, dependent: :delete_all
    has_many model, through: "character_#{model}".to_sym
  end

  def refresh
    XIVAPI_CLIENT.character_update(id: self.id)
    Character.fetch(self.id, true)
  end

  def triple_triad
    verified_user&.triple_triad
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

  def self.fetch(id, skip_cache = false)
    if !skip_cache && character = Character.find_by(id: id)
      return character
    end

    result = XIVAPI_CLIENT.character(id: id, all_data: true, poll: true, columns: CHARACTER_COLUMNS)
    Character.update(result)
  end

  def self.sync(ids)
    XIVAPI_CLIENT.characters(ids: ids, all_data: true, columns: CHARACTER_COLUMNS).each do |data|
      Character.update(data)
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
    return if data.info.character.state != 2 # Only cached characters can be updated

    if data.free_company.present?
      fc = data.free_company.to_h.slice(:id, :name, :tag)
      if existing = FreeCompany.find_by(id: fc[:id])
        existing.update!(fc)
      else
        FreeCompany.create!(fc)
      end
    end

    info = data.character.to_h.slice(:id, :name, :server, :portrait, :avatar, :free_company_id)
    info[:last_parsed] = Time.at(data.character.parse_date)
    info[:achievements_count] = -1 if data.info.achievements.state == 5 # Achievements set to private

    if character = Character.find_by(id: info[:id])
      character.update(info)
    else
      character = Character.create!(info)
    end

    if data.achievements.present?
      achievement_ids = character.achievement_ids
      achievements = data.achievements.list.reject { |achievement| achievement_ids.include?(achievement.id) }
      Character.bulk_insert_achievements(info[:id], achievements)
      character.update(achievement_points: character.achievements.sum(:points))
    end

    Character.bulk_insert(info[:id], CharacterMount, :mount, data.character.mounts - character.mount_ids)
    Character.bulk_insert(info[:id], CharacterMinion, :minion,
                          data.character.minions - character.minion_ids - Minion.unsummonable_ids)

    Character.find(info[:id])
  end

  def self.bulk_insert(character_id, model, model_name, ids)
    return unless ids.present?
    date = Time.now.to_formatted_s(:db)
    values = ids.map { |id| "(#{character_id}, #{id}, '#{date}', '#{date}')" }
    model.connection.execute("INSERT INTO #{model.table_name}(character_id, #{model_name}_id, created_at, updated_at)" \
                             " values #{values.join(',')}")
    Character.reset_counters(character_id, "#{model_name}s_count")
  end

  def self.bulk_insert_achievements(character_id, achievements)
    return unless achievements.present?

    values = achievements.map do |achievement|
      date = Time.at(achievement.date).to_formatted_s(:db)
      "(#{character_id}, #{achievement.id}, '#{date}', '#{date}')"
    end

    CharacterAchievement.connection
      .execute("INSERT INTO character_achievements(character_id, achievement_id, created_at, updated_at)" \
               " values #{values.join(',')}")
    Character.reset_counters(character_id, :achievements_count)
  end

  def clear_user_characters
    User.where(character_id: self.id).update_all(character_id: nil)
  end
end
