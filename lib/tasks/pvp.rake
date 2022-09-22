namespace :pvp do
  namespace :sources do
    desc 'Create PvP sources'
    task update: :environment do
      PaperTrail.enabled = false
      pvp_type = SourceType.find_by(name: 'PvP')

      puts 'Creating PvP Series sources'

      XIVData.sheet('PvPSeries', raw: true).each do |series|
        number = series['#']

        32.times do |i|
          item_id = series["LevelRewardItem[#{i}][0]"]

          if item_id != '0' && unlock = Item.find(item_id).unlock
            unless unlock.sources.any?
              unlock.sources.create!(type: pvp_type, text: "Crystalline Conflict - Series #{number} - Level #{i}")
            end
          end
        end
      end
    end
  end
end
