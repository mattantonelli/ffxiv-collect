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
#  refreshed_at       :datetime         default(Thu, 01 Jan 1970 00:00:00 UTC +00:00)
#  gender             :string(255)
#  spells_count       :integer          default(0)
#  items_count        :integer          default(0)
#  queued_at          :datetime         default(Thu, 01 Jan 1970 00:00:00 UTC +00:00)
#  fashions_count     :integer          default(0)
#

class Character < ApplicationRecord
  after_destroy :clear_user_characters
  belongs_to :verified_user, class_name: 'User', required: false
  belongs_to :free_company, required: false

  scope :recent,   -> { where('characters.updated_at > ?', Date.current - 3.months) }
  scope :verified, -> { where.not(verified_user: nil) }
  scope :visible,  -> { where(public: true) }
  scope :with_public_achievements, -> { where('achievements_count > 0') }

  CHARACTER_API_BASE = 'https://xivapi.com/character'.freeze
  CHARACTER_COLUMNS = %w(Achievements AchievementsPublic Mounts Minions FreeCompany.ID FreeCompany.Name
    Character.Avatar Character.ID Character.Gender Character.Name Character.Portrait Character.Server).freeze
  CHARACTER_PROFILE_BASE = 'https://na.finalfantasyxiv.com/lodestone/character'.freeze

  %i(achievements mounts minions orchestrions emotes bardings hairstyles armoires spells items fashions).each do |model|
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
    page = Nokogiri::HTML(open("#{CHARACTER_PROFILE_BASE}/#{self.id}"))
    profile = page.css('.character__selfintroduction').text

    if profile.include?(verification_code(user))
      update!(verified_user_id: user.id)
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
    Sidekiq::Workers.new.any? { |_, _, worker| worker['payload']['args'][0]['arguments'][0] == self.id }
  end

  def refreshable?
    refreshed_at < Time.now - 30.minutes
  end

  def syncable?
    stale? && queued_at < Time.now - 30.minutes
  end

  def most_recent(collection, filters: nil)
    collectables = send(collection).order("character_#{collection}.created_at desc")
    collectables = collectables.with_filters(filters, self) if filters.present?
    collectables.first(10)
  end

  def most_rare(collection, filters: nil)
    rarities = Redis.current.hgetall(collection)
    sorted_ids = rarities.sort_by { |k, v| v.to_f }.map { |k, v| k.to_i }
    valid_ids = rarities.keys.map(&:to_i) # Exclude new collectables with no rarity values

    collectables = send(collection)
    collectables = collectables.with_filters(filters, self) if filters.present?
    collectables = collectables.select { |collectable| valid_ids.include?(collectable.id) }
      .sort_by { |collectable| sorted_ids.index(collectable.id) }

    collectables.first(10).map do |collectable|
      [collectable, rarities[collectable.id.to_s]]
    end
  end

  def self.fetch(id, basic: false)
    if basic
      character = XIVAPI_CLIENT.character(id: id, columns: CHARACTER_COLUMNS)
      Character.retrieve(character)
    else
      character = XIVAPI_CLIENT.character(id: id, data: %w(AC MIMO FC), columns: CHARACTER_COLUMNS)
      Character.update(character)
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
  def self.retrieve(data)
    gender = data.character.gender == 1 ? 'male' : 'female'

    info = { id: data.character.id, name: data.character.name, server: data.character.server,
             gender: gender, portrait: data.character.portrait, avatar: data.character.avatar,
             free_company_id: data.dig(:free_company, :id), last_parsed: Time.now }

    info[:achievements_count] = -1 unless data.achievements_public

    if character = Character.find_by(id: info[:id])
      character.update(info)
    else
      character = Character.create!(info)
    end

    character
  end

  def self.update(data)
    character = Character.retrieve(data)

    if data.dig(:free_company, :id).present?
      fc = { id: data.free_company.id, name: data.free_company.name }

      if existing = FreeCompany.find_by(id: fc[:id])
        existing.update!(fc)
      else
        FreeCompany.create!(fc)
      end

      character.update(free_company_id: data.free_company.id)
    end

    if data.achievements_public
      current_ids = CharacterAchievement.where(character_id: character.id).pluck(:achievement_id)
      achievements = data.achievements.list.reject { |achievement| current_ids.include?(achievement.id) }
      Character.bulk_insert_achievements(character, achievements)
    end

    current_names = CharacterMount.joins(:mount).where(character_id: character.id).pluck(:name_en).map(&:downcase)
    names = data.mounts.reject { |mount| current_names.include?(mount.name.downcase) }.pluck(:name)
    Character.bulk_insert(character.id, CharacterMount, :mount, Mount.where(name_en: names).pluck(:id))

    current_names = CharacterMinion.joins(:minion).where(character_id: character.id).pluck(:name_en).map(&:downcase)
    names = data.minions.reject { |minion| current_names.include?(minion.name.downcase) }.pluck(:name)
    Character.bulk_insert(character.id, CharacterMinion, :minion,
                          Minion.where(name_en: names).pluck(:id) - Minion.unsummonable_ids)

    character
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
      date = Time.at(achievement.date).to_formatted_s(:db)
      "(#{character.id}, #{achievement.id}, '#{date}', '#{date}')"
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
