require 'csv'

RECIPE_COLUMNS = %w(ID ClassJob.Name_en).freeze
QUEST_COLUMNS = %w(ID Name_* ItemReward00 ItemReward01 ItemReward02 ItemReward03 ItemReward04
ItemReward05 FestivalTargetID).freeze
ITEM_COLUMNS = %w(ID Name_en Description_en ItemAction.Data0 GameContentLinks.Achievement.Item
GameContentLinks.Recipe.ItemResult IsUntradable).freeze

namespace :sources do
  desc 'Create the source types'
  task create_types: :environment do
    names = ['Achievement', 'Crafting', 'Deep Dungeon', 'Dungeon', 'Eureka', 'Event', 'FATE', 'Feast', 'Gathering',
             'Other', 'Purchase', 'Quest', 'Raid', 'Treasure Hunt', 'Trial', 'Venture', 'Premium', 'Limited']

    names.each do |name|
      SourceType.find_or_create_by!(name: name)
    end
  end

  desc 'Initializes source data for various collectables'
  task initialize: :environment do
    PaperTrail.enabled = false

    puts 'Setting initial collectable sources'

    sources = SourceType.pluck(:name, :id).to_h

    %w(armoires bardings emotes hairstyles minions mounts).each do |type|
      file = Rails.root.join('vendor/sources', "#{type}.csv")
      model = type.classify.constantize
      CSV.foreach(file) do |row|
        data = { type_id: sources[row[1]], text: row[2] }

        if row[1] == 'Achievement'
          data.merge!(related_type: 'Achievement', related_id: Achievement.find_by(name_en: row[2]).id)
        elsif Instance.valid_types.include?(row[1])
          if related_id = Instance.find_by(name_en: row[2])&.id
            data.merge!(related_type: 'Instance', related_id: related_id)
          end
        elsif row[1] == 'Quest'
          if related_id = Quest.find_by(name_en: row[2])&.id
            data.merge!(related_type: 'Quest', related_id: related_id)
          end
        end

        if model.find_by(name_en: row[0]).try(:sources) != nil
          model.find_by(name_en: row[0]).sources.find_or_create_by!(data)
        else
          puts "#{type} - #{row[0]} - Could not be imported"
        end
      end
    end
  end

  desc 'Sets item IDs and known sources for various collectables'
  task update: :environment do
    PaperTrail.enabled = false

    achievement_type, crafting_type, event_type, quest_type =
      SourceType.where(name: %w(Achievement Crafting Event Quest)).order(:name).pluck(:id)

    # Mapping of internal values for ItemAction.Type
    collections = { Mount => 1322, Minion => 853, Orchestrion => 5845, Emote => 2633, Barding => 1013, Hairstyle => 2633 }

    # Exclude limited time achievement sources because they are a mess to filter
    valid_achievement_ids = Achievement.exclude_time_limited.pluck(:id) - [1771, 1772, 1773] # Also exclude GARO

    collectables = collections.each_with_object({}) do |(collection, type), h|
      XIVAPI_CLIENT.search(indexes: 'Item', columns: ITEM_COLUMNS, filters: "ItemAction.Type=#{type}", limit: 999).each do |item|
        if collection == Emote
          next unless item.name_en.match?('Ballroom Etiquette')
          command = item.description_en.match(/(\/.*) emote/).captures.first
          collectable = collection.where('command_en like ?', "%#{command}%").first
        elsif collection == Hairstyle
          next unless item.name_en.match?('Modern Aesthetics')
          collectable = collection.find_by(name_en: item.name_en.gsub(/.* - /, ''))
        else
          collectable = collection.find(item.item_action.data0)
        end

        collectable.update!(item_id: item.id) if item.is_untradable == 0

        next if collection == Orchestrion

        achievement_id = item.game_content_links.achievement.item&.first
        if achievement_id.present? && valid_achievement_ids.include?(achievement_id)
          achievement = Achievement.find(achievement_id)
          collectable.sources.find_or_create_by!(text: achievement.name_en, type_id: achievement_type,
                                                 related_type: 'Achievement', related_id: achievement_id)
        end

        recipe_id = item.game_content_links.recipe.item_result&.first
        if recipe_id.present? && !collectable.sources.exists?(type_id: crafting_type)
          collectable.sources.create!(type_id: crafting_type, related_id: recipe_id)
        end

        h[item.id] = collectable
      end
    end

    collectable_ids = collectables.keys
    XIVAPI_CLIENT.search(indexes: 'Quest', columns: QUEST_COLUMNS, filters: 'ItemReward00>0', limit: 10000)
      .each_with_object({}) do |quest, h|
      (0..5).each do |i|
        reward = quest["item_reward0#{i}"]
        break if reward == 0

        if collectable_ids.include?(reward)
          type_id = quest.festival_target_id > 0 ? event_type : quest_type
          collectables[reward].sources.find_or_create_by!(text: quest.name_en, type_id: type_id,
                                                          related_type: 'Quest', related_id: quest.id)
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
