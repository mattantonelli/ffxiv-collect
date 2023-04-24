namespace :sources do
  desc 'Create the source types'
  task create_types: :environment do
    names = ['Achievement', 'Crafting', 'Deep Dungeon', 'Dungeon', 'Eureka', 'Event', 'FATE', 'PvP', 'Gathering',
             'Other', 'Purchase', 'Quest', 'Raid', 'Treasure Hunt', 'Trial', 'Venture', 'Premium', 'Limited']

    names.each do |name|
      SourceType.find_or_create_by!(name_en: name)
    end
  end

  desc 'Initialize source data for various collectables'
  task initialize: :environment do
    PaperTrail.enabled = false

    puts 'Setting initial collectable sources'

    sources = SourceType.pluck(:name_en, :id).to_h

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

        if collectable = model.find_by(name_en: row[0])
          collectable.sources.find_or_create_by!(data)
        end
      end
    end
  end

  desc 'Set automated collectable sources'
  task update: :environment do
    Rake::Task['sources:achievements:update'].invoke
    Rake::Task['sources:crafting:update'].invoke
    Rake::Task['sources:orchestrions:update'].invoke
    Rake::Task['sources:pvp:update'].invoke
    Rake::Task['sources:quests:update'].invoke
    Rake::Task['sources:shops:update'].invoke
  end
end
