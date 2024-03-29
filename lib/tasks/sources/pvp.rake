namespace 'sources:pvp' do
  desc 'Create PvP sources'
  task update: :environment do
    PaperTrail.enabled = false
    pvp_type = SourceType.find_by(name_en: 'PvP')

    puts 'Creating PvP Series sources'

    XIVData.sheet('PvPSeries', raw: true).each do |series|
      number = series['#']

      32.times do |i|
        item_id = series["LevelRewardItem[#{i}][0]"]

        if item_id != '0' && unlock = Item.find(item_id).unlock
          unless unlock.sources.any?
            unlock.sources.create!(text: "Crystalline Conflict - Series #{number} - Level #{i}",
                                   type: pvp_type, limited: true)
          end
        end
      end
    end
  end
end
