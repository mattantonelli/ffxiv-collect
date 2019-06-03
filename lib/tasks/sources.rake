require 'csv'

RECIPE_COLUMNS = %w(ID ClassJob.Name_en).freeze
ITEM_COLUMNS = %w(ID Name_en Description_en ItemAction.Data0 GameContentLinks.Achievement.Item
GameContentLinks.Recipe.ItemResult IsUntradable).freeze

namespace :sources do
  desc 'Create the source types'
  task create_types: :environment do
    names = ['Achievement', 'Crafting', 'Deep Dungeon', 'Dungeon', 'Eureka', 'Event', 'FATE', 'Feast,' 'Gathering',
             'Mog Station', 'Other', 'Purchase', 'Quest', 'Raid', 'Treasure Hunt', 'Trial', 'Venture']

    names.each do |name|
      SourceType.find_or_create_by!(name: name)
    end
  end

  desc 'Initializes source data for various collectables'
  task initialize: :environment do
    puts 'Setting initial collectable sources'

    sources = SourceType.pluck(:name, :id).to_h

    %w(armoires bardings emotes hairstyles minions mounts).each do |type|
      file = Rails.root.join('vendor/sources', "#{type}.csv")
      model = type.classify.constantize
      CSV.foreach(file) do |row|
        data = { type_id: sources[row[1]], text: row[2] }

        if row[1] == 'Achievement'
          data[:related_id] = Achievement.find_by(name_en: row[2]).id
        end

        model.find_by(name_en: row[0]).sources.find_or_create_by!(data)
      end
    end
  end

  desc 'Sets item IDs and known sources for various collectables'
  task update: :environment do
    achievement_type, crafting_type = SourceType.where(name: ['Achievement', 'Crafting']).pluck(:id)
    collections = { Mount => 1322, Minion => 853, Orchestrion => 5845, Emote => 2633, Barding => 1013, Hairstyle => 2633 }

    collections.each do |collection, type|
      XIVAPI_CLIENT.search(indexes: 'Item', columns: ITEM_COLUMNS, filters: "ItemAction.Type=#{type}", limit: 999).each do |item|
        if collection == Emote
          next unless item.name_en.match?('Ballroom Etiquette')
          command = item.description_en.match(/(\/.*) emote/).captures.first
          collectable = collection.find_by(command_en: command)
        elsif collection == Hairstyle
          next unless item.name_en.match?('Modern Aesthetics')
          collectable = collection.find_by(name_en: item.name_en.gsub(/.* - /, ''))
        else
          collectable = collection.find(item.item_action.data0)
        end

        collectable.update!(item_id: item.id) if item.is_untradable == 0

        next if collection == Orchestrion

        achievement_id = item.game_content_links.achievement.item&.first
        if achievement_id.present?
          achievement = Achievement.find(achievement_id)
          collectable.sources.find_or_create_by!(text: achievement.name_en, type_id: achievement_type,
                                                 related_id: achievement_id)
        end

        recipe_id = item.game_content_links.recipe.item_result&.first
        if recipe_id.present? && !collectable.sources.exists?(type_id: crafting_type)
          collectable.sources.create!(type_id: crafting_type, related_id: recipe_id)
        end
      end
    end

    recipe_ids = Source.where(type_id: crafting_type).pluck(:related_id)
    XIVAPI_CLIENT.content(name: 'Recipe', ids: recipe_ids, columns: RECIPE_COLUMNS, limit: 1000).each do |recipe|
      text = "Crafted by #{recipe.class_job.name_en.capitalize}"
      Source.where(type_id: crafting_type, related_id: recipe.id).update_all(text: text)
    end
  end
end
