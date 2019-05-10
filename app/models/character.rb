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
  %i(achievements mounts minions orchestrions emotes bardings hairstyles armoires).each do |model|
    has_many "character_#{model}".to_sym, dependent: :delete_all
    has_many model, through: "character_#{model}".to_sym
  end

  def refresh
    Character.fetch(self.id)
  end

  def self.fetch(id)
    result = XIVAPI_CLIENT.character(id: id, all_data: true, poll: true)
    character = result.character
    data = { id: character.id, name: character.name, server: character.server,
             portrait: character.portrait, avatar: character.avatar,
             last_parsed: Time.at(character.parse_date),
             achievement_ids: result.achievements&.list&.map(&:id) || [],
             mount_ids: character.mounts, minion_ids: character.minions }

    puts character.mounts.join(',')
    puts character.minions.join(',')

    unless Character.exists?(id)
      Character.create!(data.except(:achievement_ids, :mount_ids, :minion_ids))
    end

    Character.bulk_insert(data[:id], CharacterAchievement, :achievement_id, data[:achievement_ids])
    Character.bulk_insert(data[:id], CharacterMount, :mount_id, data[:mount_ids])
    Character.bulk_insert(data[:id], CharacterMinion, :minion_id, data[:minion_ids])
    Character.reset_counters(data[:id], :achievements_count, :mounts_count, :minions_count)
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
  def self.bulk_insert(character_id, model, model_column, ids)
    return unless ids.present?
    date = Time.now.to_formatted_s(:db)
    values = ids.map { |id| "(#{character_id}, #{id}, '#{date}', '#{date}')" }
    model.connection.execute("INSERT IGNORE INTO #{model.table_name}(character_id, #{model_column}, created_at, updated_at)" \
                             " values #{values.join(',')}")
  end
end
