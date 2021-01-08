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

    categories.each do |name, ids|
      XIVAPI_CLIENT.content(name: 'Item', columns: %w(ID Name_* Icon), ids: ids, limit: 1000).map do |item|
        data = { id: item.id }

        %w(en de fr ja).each do |locale|
          data["name_#{locale}"] = sanitize_name(item["name_#{locale}"])
        end

        download_image(data[:id], item.icon, "relics/#{name}")

        if existing = Relic.find_by(id: item.id)
          data = without_custom(data)
          existing.update!(data) if updated?(existing, data.symbolize_keys)
        else
          Relic.create!(data)
        end
      end

      create_spritesheet("relics/#{name}")
    end

    puts "Created #{Relic.count - count} new relics"
  end
end
