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

        model.find_by(name_en: row[0]).sources.find_or_create_by!(data)
      end
    end
  end

  desc 'Sets achievement, quest, and crafting sources for collectables'
  task update: :environment do
    PaperTrail.enabled = false

    achievement_type, crafting_type, event_type, quest_type =
      SourceType.where(name: %w(Achievement Crafting Event Quest)).order(:name).pluck(:id)

    # Create sources from Achievement rewards for non-time limited (or GARO) quests
    achievements = Achievement.exclude_time_limited.where.not(id: [1771, 1772, 1773])
      .joins(:item).where('items.unlock_type is not null')

    achievements.each do |achievement|
      Source.find_or_create_by!(collectable_id: achievement.item.unlock_id,
                                collectable_type: achievement.item.unlock_type,
                                text: achievement.name_en, type_id: achievement_type, related_id: achievement.id)
    end

    # Create sources from Quest rewards
    quests = Quest.where.not(reward_id: nil)
      .joins(:reward).where('items.unlock_type IS NOT NULL')

    quests.each do |quest|
      source_type = quest.event? ? event_type : quest_type
      Source.find_or_create_by!(collectable_id: quest.reward.unlock_id,
                                collectable_type: quest.reward.unlock_type,
                                text: quest.name_en, type_id: source_type, related_id: quest.id)
    end

    # Created sources from craftable Items
    Item.where.not(unlock_type: nil, recipe_id: nil).each do |item|
      Source.find_or_create_by!(collectable_id: item.unlock_id, collectable_type: item.unlock_type,
                                text: "Crafted by #{item.crafter}", type_id: crafting_type, related_id: item.recipe_id)
    end
  end
end
