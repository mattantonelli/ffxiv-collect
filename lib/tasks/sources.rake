require 'csv'

namespace :sources do
  desc 'Sets initial source data for various collectables'
  task set: :environment do
    puts 'Setting initial collectable sources'

    source_names = ['Achievement', 'Category', 'Crafting', 'Deep Dungeon', 'Dungeon', 'Eureka', 'Event', 'FATE', 'Feast,'
                    'Gathering', 'Mog Station', 'Other', 'Purchase', 'Quest', 'Raid', 'Treasure Hunt', 'Trial', 'Venture']

    source_names.each_with_index do |name, i|
      SourceType.find_or_create_by!(id: i + 1, name: name)
    end

    sources = source_names.zip(1..(source_names.size)).to_h

    %w(armoires bardings emotes hairstyles minions mounts).each do |type|
      file = Rails.root.join('vendor/sources', "#{type}.csv")
      model = type.classify.constantize
      CSV.foreach(file) do |row|
        model.find_by(name_en: row[0]).sources.find_or_create_by!(type_id: sources[row[1]], text: row[2])
      end
    end
  end
end
