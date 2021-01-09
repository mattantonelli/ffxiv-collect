require 'xiv_data'

namespace :fashions do
  desc 'Create the fashion accessories'
  task create: :environment do
    PaperTrail.enabled = false

    puts 'Creating fashion accessories'

    count = Fashion.count
    fashions = %w(en de fr ja).each_with_object({}) do |locale, h|
      XIVData.sheet('Ornament', locale: locale).each do |fashion|
        next unless fashion['Singular'].present?

        data = h[fashion['#']] || { id: fashion['#'], order: fashion['Order'],
                                    icon: fashion['Icon'], icon_large: fashion['Icon'].gsub('/008', '/067') }
        data["name_#{locale}"] = sanitize_name(fashion['Singular'])
        h[data[:id]] = data
      end
    end

    # Set Fashion accessory descriptions from the item that unlocks them
    Item.where(unlock_type: 'fashion').each do |item|
      data = fashions[item.unlock_id.to_s]
      data.merge!(item.slice(:description_en, :description_de, :description_fr, :description_ja))
      data[:item_id] = item.id if item.tradeable?
    end

    fashions.values.each do |fashion|
      create_image(fashion[:id], fashion.delete(:icon), 'fashions/small')
      create_image(fashion[:id], fashion.delete(:icon_large), 'fashions/large')

      if existing = Fashion.find_by(id: fashion[:id])
        existing.update!(fashion) if updated?(existing, fashion)
      else
        Fashion.create!(fashion)
      end
    end

    create_spritesheet('fashions/small')

    puts "Created #{Fashion.count - count} new fashion accessories"
  end
end
