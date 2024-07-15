# == Schema Information
#
# Table name: characters
#
#  id                           :bigint(8)        not null, primary key
#  name                         :string(255)      not null
#  server                       :string(255)      not null
#  portrait                     :string(255)
#  avatar                       :string(255)      not null
#  last_parsed                  :datetime
#  verified_user_id             :integer
#  achievements_count           :integer          default(0)
#  mounts_count                 :integer          default(0)
#  minions_count                :integer          default(0)
#  orchestrions_count           :integer          default(0)
#  emotes_count                 :integer          default(0)
#  bardings_count               :integer          default(0)
#  hairstyles_count             :integer          default(0)
#  armoires_count               :integer          default(0)
#  created_at                   :datetime         not null
#  updated_at                   :datetime         not null
#  public                       :boolean          default(TRUE)
#  achievement_points           :integer          default(0)
#  free_company_id              :string(255)
#  refreshed_at                 :datetime         default(Thu, 01 Jan 1970 00:00:00.000000000 UTC +00:00)
#  gender                       :string(255)
#  spells_count                 :integer          default(0)
#  relics_count                 :integer          default(0)
#  queued_at                    :datetime         default(Thu, 01 Jan 1970 00:00:00.000000000 UTC +00:00)
#  fashions_count               :integer          default(0)
#  records_count                :integer          default(0)
#  data_center                  :string(255)
#  ranked_achievement_points    :integer          default(0)
#  ranked_mounts_count          :integer          default(0)
#  ranked_minions_count         :integer          default(0)
#  last_ranked_achievement_time :datetime
#  survey_records_count         :integer          default(0)
#  frames_count                 :integer          default(0)
#  banned                       :boolean          default(FALSE)
#  cards_count                  :integer          default(0)
#  npcs_count                   :integer          default(0)
#  leves_count                  :integer          default(0)
#  public_achievements          :boolean          default(FALSE)
#  public_profile               :boolean          default(TRUE)
#  public_mounts                :boolean          default(TRUE)
#  public_minions               :boolean          default(TRUE)
#  public_facewear              :boolean          default(TRUE)
#  facewear_count               :integer          default(0)
#

class Character < ApplicationRecord
  include Queueable

  after_destroy :clear_user_characters
  belongs_to :verified_user, class_name: 'User', required: false
  belongs_to :free_company, required: false

  has_many :group_memberships
  has_many :groups, through: :group_memberships

  scope :recent,   -> { where('characters.updated_at > ?', Date.current - 3.months) }
  scope :verified, -> { where.not(verified_user: nil) }
  scope :visible,  -> { where(public: true, banned: false) }
  scope :with_public_achievements, -> { where(public_achievements: true) }

  %i(achievements mounts minions orchestrions emotes bardings hairstyles armoires spells relics
  fashions facewear records survey_records frames leves cards npcs).each do |model|
    has_many "character_#{model}".to_sym, dependent: :delete_all
    has_many model, through: "character_#{model}".to_sym
  end

  def sync
    update(queued_at: Time.now)
    CharacterSyncJob.perform_later(id)
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

  def expire!
    time = Time.at(0)
    update!(last_parsed: time, queued_at: time, refreshed_at: time)
  end

  def stale?
    last_parsed < Time.now - 6.hours
  end

  def refreshable?
    refreshed_at < Time.now - 30.minutes
  end

  def syncable?
    stale? && !in_queue?
  end

  def most_recent(collection, filters: nil, limit: 10)
    if collection == 'titles'
      collectables = achievements.joins(:title).includes(:title).order('character_achievements.created_at desc')
    else
      collectables = send(collection).order("character_#{collection}.created_at desc")
    end

    # Only show half as many Field Records due to the size of their icons
    limit /= 2 if collection == 'records'

    collectables = collectables.with_filters(filters, self) if filters.present?
    collectables.first(limit).map do |collectable|
      { collectable: collectable }
    end
  end

  def most_rare(collection, filters: nil, limit: 10)
    if collection == 'titles'
      collectables = achievements.joins(:title).includes(:title)
      key = 'achievements'
    else
      collectables = send(collection)
      key = collection
    end

    rarities = {
      count: Redis.current.hgetall("#{key}-count"),
      percentage: Redis.current.hgetall(key)
    }

    sorted_ids = rarities[:count].sort_by { |k, v| v.to_f }.map { |k, v| k.to_i }
    valid_ids = rarities[:count].keys.map(&:to_i) # Exclude new collectables with no rarity values

    collectables = collectables.with_filters(filters, self) if filters.present?
    collectables = collectables.select { |collectable| valid_ids.include?(collectable.id) }
      .sort_by { |collectable| sorted_ids.index(collectable.id) }

    # Only show half as many Field Records due to the size of their icons
    limit /= 2 if collection == 'records'

    collectables.first(limit).map do |collectable|
      { collectable: collectable,
        count: rarities[:count][collectable.id.to_s],
        percentage: rarities[:percentage][collectable.id.to_s] }
    end
  end

  def rankings
    %i(achievements mounts minions).each_with_object({}) do |category, h|
      h[category] = {
        server: Redis.current.hget("rankings-#{category}-#{server.downcase}", id)&.to_i,
        data_center: Redis.current.hget("rankings-#{category}-#{data_center.downcase}", id)&.to_i,
        global: Redis.current.hget("rankings-#{category}-global", id)&.to_i
      }
    end
  end

  def region
    case data_center
    when 'Aether', 'Crystal', 'Dynamis', 'Primal'
      'na'
    when 'Chaos', 'Light', 'Materia'
      'eu'
    when 'Elemental', 'Gaia', 'Mana', 'Meteor'
      'jp'
    else
      'na'
    end
  end

  def fetch!
    Character.fetch(id)
  end

  def import_triple_triad_progress!(card_ids:, npc_ids:)
    if card_ids.present?
      cards.delete_all
      Character.bulk_insert(self.id, CharacterCard, :card, card_ids)
    end

    if npc_ids.present?
      npcs.delete_all
      Character.bulk_insert(self.id, CharacterNPC, :npc, npc_ids)
    end
  end

  def set_cards(ids)
    old_ids = self.card_ids

    # Bulk insert the newly added cards
    add_ids = ids - old_ids
    if add_ids.present?
      Character.bulk_insert(self.id, CharacterCard, :card, add_ids)
    end

    # Bulk delete the newly removed cards
    remove_ids = old_ids - ids
    if remove_ids.present?
      CharacterCard.where(character_id: self.id, card_id: remove_ids).delete_all
    end

    # Update the counter cache
    Character.reset_counters(self.id, :cards_count)
  end

  def set_npcs(ids)
    if ids.present?
      Character.bulk_insert(self.id, CharacterNPC, :npc, ids)
    end
  end

  def self.fetch(id)
    data = Lodestone.character(id)

    # Remove character from rankings when achievements have been set to private
    data[:ranked_achievement_points] = -1 unless data[:public_achievments]
    data[:ranked_mounts_count] = -1 unless data[:public_mounts]
    data[:ranked_minions_count] = -1 unless data[:public_minions]

    profile_data = data.except(:achievements, :mounts, :minions, :facewear)

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
      "Chaos" => %w(Cerberus Louisoix Moogle Omega Phantom Ragnarok Sagittarius Spriggan),
      "Crystal" => %w(Balmung Brynhildr Coeurl Diabolos Goblin Malboro Mateus Zalera),
      "Dynamis" => %w(Halicarnassus Maduin Marilith Seraph Cuchulainn Golem Kraken Rafflesia),
      "Elemental" => %w(Aegis Atomos Carbuncle Garuda Gungnir Kujata Tonberry Typhon),
      "Gaia" => %w(Alexander Bahamut Durandal Fenrir Ifrit Ridill Tiamat Ultima),
      "Light" => %w(Alpha Lich Odin Phoenix Raiden Shiva Zodiark Twintania),
      "Mana" => %w(Anima Asura Chocobo Hades Ixion Masamune Pandaemonium Titan),
      "Materia" => %w(Bismarck Ravana Sephirot Sophia Zurvan),
      "Meteor" => %w(Belias Mandragora Ramuh Shinryu Unicorn Valefor Yojimbo Zeromus),
      "Primal" => %w(Behemoth Excalibur Exodus Famfrit Hyperion Lamia Leviathan Ultros)
    }.freeze
  end

  def self.leaderboards(characters:, metric:, data_center: nil, server: nil, limit: nil, rankings: false)
    q = { data_center_eq: data_center, server_eq: server, "#{metric}_gt" => 0 }.compact
    ranked_characters = characters.ransack(q).result

    # Exclude characters with private collections
    case metric
    when /achievement/
      ranked_characters = ranked_characters.where(public_achievements: true)
    when /mount/
      ranked_characters = ranked_characters.where(public_mounts: true)
    when /minion/
      ranked_characters = ranked_characters.where(public_minions: true)
    when /facewear/
      ranked_characters = ranked_characters.where(public_facewear: true)
    end

    # Order the results based on the metric
    if metric.match?('achievement')
      ranked_characters = ranked_characters
        .order(metric => :desc, last_ranked_achievement_time: :asc, name: :asc)
        .limit(limit)
    else
      ranked_characters = ranked_characters
        .order(metric => :desc, name: :asc)
        .limit(limit)
    end

    # Only select necessary columns when caching rankings
    if rankings
      if metric.match?('achievement')
        ranked_characters = ranked_characters.select(:id, metric, :last_ranked_achievement_time)
      else
        ranked_characters = ranked_characters.select(:id, metric)
      end
    end

    return [] if ranked_characters.empty?

    current_score = ranked_characters[0][metric]
    current_date = ranked_characters[0].last_ranked_achievement_time if metric.match?('achievement')
    rank = 1

    ranked_characters.map.with_index(1) do |character, i|
      score = character[metric]

      if metric.match?('achievement')
        date = character.last_ranked_achievement_time

        if score != current_score || date != current_date
          rank = i
          current_score = score
          current_date = date
        end
      else
        if score != current_score
          rank = i
          current_score = score
        end
      end

      { rank: rank, character: character, score: score, date: date }
    end
  end

  def self.available_filters
    %i(gender premium limited ranked_pvp unknown)
  end

  private
  def self.update_collectables!(character, data)
    # Achievements
    character_achievements = CharacterAchievement.where(character_id: character.id)

    # Don't update achievements if the character has not earned any new ones
    if data[:achievements].present?
      current_ids = character_achievements.pluck(:achievement_id)
      achievements = data[:achievements].reject { |achievement| current_ids.include?(achievement[:id]) }

      Character.bulk_insert_with_dates(character.id, CharacterAchievement, :achievement, achievements)
      character.update(achievement_points: character.achievements.sum(:points))
    end

    is_now_public = character.public_achievements && character.ranked_achievement_points == -1

    # Don't update rankings if the character has not earned any new achievements,
    # unless the character has toggled their Lodestone privacy settings.
    if data[:achievements].present? || is_now_public
      ranked_time = CharacterAchievement.where(character_id: character.id)
        .joins(:achievement).merge(Achievement.exclude_time_limited)
        .order(:created_at).last.created_at

      character.update(ranked_achievement_points: character.achievements.exclude_time_limited.sum(:points),
                       last_ranked_achievement_time: ranked_time)
    end

    # Relics - Update based on ALL of a character's record achievements so we can add them retroactively
    current_relic_ids = CharacterRelic.where(character_id: character.id).pluck(:relic_id)
    relic_id_map = Relic.where.not(achievement_id: nil).pluck(:id, :achievement_id).to_h
    relic_achievement_ids = relic_id_map.values

    relics = character_achievements.flat_map do |achievement|
      achievement_id = achievement.achievement_id

      if relic_achievement_ids.include?(achievement_id)
        relic_id_map.filter_map do |r_id, a_id|
          if a_id == achievement_id && !current_relic_ids.include?(r_id)
            { id: r_id, date: achievement.created_at.to_formatted_s(:db) }
          end
        end
      end
    end

    Character.bulk_insert_with_dates(character.id, CharacterRelic, :relic, relics.compact)

    # Mounts
    current_ids = CharacterMount.where(character_id: character.id).pluck(:mount_id)
    new_mounts = data[:mounts].reject { |id| current_ids.include?(id) }

    if new_mounts.present?
      Character.bulk_insert(character.id, CharacterMount, :mount, new_mounts)
    end

    # Re-check the ranked count since sources can change, unless the collection is private
    if character.public_mounts?
      character.update(ranked_mounts_count: character.mounts.ranked.count)
    end

    # Minions
    current_ids = CharacterMinion.where(character_id: character.id).pluck(:minion_id)
    new_minions = data[:minions].reject { |id| current_ids.include?(id) }

    if new_minions.present?
      Character.bulk_insert(character.id, CharacterMinion, :minion, new_minions)
    end

    # Re-check the ranked count since sources can change, unless the collection is private
    if character.public_minions?
      character.update(ranked_minions_count: character.minions.ranked.count)
    end

    # Facewear
    current_ids = CharacterFacewear.where(character_id: character.id).pluck(:facewear_id)
    new_facewear = data[:facewear].reject { |id| current_ids.include?(id) }

    if new_facewear.present?
      Character.bulk_insert(character.id, CharacterFacewear, :facewear, new_facewear)
    end

    Character.find(character.id)
  end

  def self.bulk_insert(character_id, model, model_name, ids)
    date = Time.now.to_formatted_s(:db)
    values = ids.map { |id| "(#{character_id}, #{id}, '#{date}', '#{date}')" }
    model.connection.execute("INSERT INTO #{model.table_name}(character_id, #{model_name}_id, created_at, updated_at)" \
                             " values #{values.join(',')}")
    Character.reset_counters(character_id, "#{model_name.to_s.pluralize}_count")
  end

  def self.bulk_insert_with_dates(character_id, model, model_name, collectables)
    return unless collectables.present?

    values = collectables.map do |collectable|
      "(#{character_id}, #{collectable[:id]}, '#{collectable[:date]}', '#{collectable[:date]}')"
    end

    model.connection.execute("INSERT INTO #{model.table_name}(character_id, #{model_name}_id, created_at, updated_at)" \
                             " values #{values.join(',')}")

    Character.reset_counters(character_id, "#{model_name.to_s.pluralize}_count")
  end

  def clear_user_characters
    User.where(character_id: self.id).update_all(character_id: nil)
  end
end
