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
#  relics_count       :integer          default(0)
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

  %i(achievements mounts minions orchestrions emotes bardings hairstyles armoires spells relics fashions).each do |model|
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
    if Lodestone.verified?(id, verification_code(user))
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
    if collection == 'titles'
      collectables = achievements.joins(:title).order('character_achievements.created_at desc')
    else
      collectables = send(collection).order("character_#{collection}.created_at desc")
    end

    collectables = collectables.with_filters(filters, self) if filters.present?
    collectables.first(10)
  end

  def most_rare(collection, filters: nil)
    if collection == 'titles'
      collectables = achievements.joins(:title)
      rarities = Redis.current.hgetall('achievements')
    else
      collectables = send(collection)
      rarities = Redis.current.hgetall(collection)
    end

    sorted_ids = rarities.sort_by { |k, v| v.to_f }.map { |k, v| k.to_i }
    valid_ids = rarities.keys.map(&:to_i) # Exclude new collectables with no rarity values

    collectables = collectables.with_filters(filters, self) if filters.present?
    collectables = collectables.select { |collectable| valid_ids.include?(collectable.id) }
      .sort_by { |collectable| sorted_ids.index(collectable.id) }

    collectables.first(10).map do |collectable|
      [collectable, rarities[collectable.id.to_s]]
    end
  end

  def self.fetch(id)
    data = Lodestone.fetch(id)
    data[:achievements_count] = -1 if data[:achievements].empty?
    profile_data = data.except(:achievements, :mounts, :minions)

    if character = Character.find_by(id: data[:id])
      character.update!(profile_data)
    else
      character = Character.create!(profile_data)
    end

    Character.update_collectables!(character, data)
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
  def self.update_collectables!(character, data)
    unless data[:achievements].empty?
      current_ids = CharacterAchievement.where(character_id: character.id).pluck(:achievement_id)
      achievements = data[:achievements].reject { |achievement| current_ids.include?(achievement[:id]) }
      Character.bulk_insert_achievements(character, achievements)
    end

    current_ids = CharacterMount.where(character_id: character.id).pluck(:mount_id)
    mounts = data[:mounts].reject { |id| current_ids.include?(id) }
    Character.bulk_insert(character.id, CharacterMount, :mount, mounts)

    current_ids = CharacterMinion.where(character_id: character.id).pluck(:minion_id)
    minions = data[:minions].reject { |id| current_ids.include?(id) }
    Character.bulk_insert(character.id, CharacterMinion, :minion, minions)

    Character.find(character.id)
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
      "(#{character.id}, #{achievement[:id]}, '#{achievement[:date]}', '#{achievement[:date]}')"
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
