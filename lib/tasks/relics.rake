namespace :relics do
  desc 'Create relics'
  task create: :environment do
    PaperTrail.enabled = false

    puts 'Creating relics'
    count = Relic.count

    categories = {
      weapons: Relic.manual_weapon_ids,
      armor: Relic.relic_armor_ids,
      tools: Relic.relic_tool_ids
    }

    categories.each do |category, ids|
      Item.where(id: ids).each do |item|
        data = { id: item.id.to_s }.merge(item.slice(:name_en, :name_de, :name_fr, :name_ja))

        create_image(data[:id], XIVData.icon_path(item.icon_id), "relics/#{category}")

        if existing = Relic.find_by(id: data[:id])
          existing.update!(data) if updated?(existing, data)
        else
          Relic.create!(data)
        end
      end

      create_spritesheet("relics/#{category}")
    end

    puts "Created #{Relic.count - count} new relics"
  end
end
