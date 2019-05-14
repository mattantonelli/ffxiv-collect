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
#

class Character < ApplicationRecord
  after_destroy :clear_user_characters

  %i(achievements mounts minions orchestrions emotes bardings hairstyles armoires).each do |model|
    has_many "character_#{model}".to_sym, dependent: :delete_all
    has_many model, through: "character_#{model}".to_sym
  end

  def refresh
    if XIVAPI_CLIENT.character_update(id: self.id)
      Character.fetch(self.id, true)
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
    user.present? && verified? && user.id == verified_user_id
  end

  def self.fetch(id, skip_cache = false)
    if !skip_cache && character = Character.find_by(id: id)
      return character
    end

    result = XIVAPI_CLIENT.character(id: id, all_data: true, poll: true)
    Character.update(result)
  end

  def self.sync(ids)
    XIVAPI_CLIENT.characters(ids: ids, all_data: true).each do |data|
      Character.update(data)
    end
  end

  def self.search(server, name)
    XIVAPI_CLIENT.character_search(server: server, name: name).to_a
  end

  def self.servers
    %w(Adamantoise Aegis Alexander Anima Asura Atomos Bahamut Balmung Behemoth Belias Brynhildr Cactuar Carbuncle
    Cerberus Chocobo Coeurl Diabolos Durandal Excalibur Exodus Faerie Famfrit Fenrir Garuda Gilgamesh Goblin Gungnir
    Hades Hyperion Ifrit Ixion Jenova Kujata Lamia Leviathan Lich Louisoix Malboro Mandragora Masamune Mateus Midgardsormr
    Moogle Odin Omega Pandaemonium Phoenix Ragnarok Ramuh Ridill Sargatanas Shinryu Shiva Siren Tiamat Titan Tonberry
    Typhon Ultima Ultros Unicorn Valefor Yojimbo Zalera Zeromus Zodiark).freeze
  end

  private
  def self.update(data)
    info = data.character.to_h.slice(:id, :name, :server, :portrait, :avatar)
    info[:last_parsed] = Time.at(data.character.parse_date)

    if character = Character.find_by(id: info[:id])
      character.update(info)
    else
      character = Character.create!(info)
    end

    achievement_ids = character.achievement_ids
    achievements = data.achievements&.list&.reject { |achievement| achievement_ids.include?(achievement.id) } || []
    Character.bulk_insert_achievements(info[:id], achievements)

    Character.bulk_insert(info[:id], CharacterMount, :mount, data.character.mounts - character.mount_ids)
    Character.bulk_insert(info[:id], CharacterMinion, :minion, data.character.minions - character.minion_ids)

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
