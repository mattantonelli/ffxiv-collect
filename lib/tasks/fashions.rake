FASHION_COLUMNS = %w(ID Name_* Icon IconSmall Item.Description_* Item.ID Item.IsUntradable Order GamePatch.Version).freeze

namespace :fashions do
  desc 'Create the fashion accessories'
  task create: :environment do
    PaperTrail.enabled = false

    puts 'Creating fashion accessories'

    count = Fashion.count
    fashions = XIVAPI_CLIENT.content(name: 'Ornament', columns: FASHION_COLUMNS, limit: 1000).map do |fashion|
      next if fashion.name_en.empty?
      data = { id: fashion.id, order: fashion.order, patch: fashion.game_patch.version }

      if fashion.item.is_untradable == 0
        data[:item_id] = fashion.item.id
      end

      %w(en de fr ja).each do |locale|
        data["name_#{locale}"] = sanitize_name(fashion["name_#{locale}"])
        data["description_#{locale}"] = sanitize_text(fashion.item["description_#{locale}"])
      end

      download_image(data[:id], fashion.icon, 'fashions/large')
      download_image(data[:id], fashion.icon_small, 'fashions/small')

      if existing = Fashion.find_by(id: data[:id])
        data = without_custom(data)
        existing.update!(data) if updated?(existing, data.symbolize_keys)
      else
        Fashion.create!(data)
      end
    end

    create_spritesheet('fashions/small')

    puts "Created #{Fashion.count - count} new fashion accessories"
  end
end
