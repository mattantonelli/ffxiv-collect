namespace :fashions do
  desc 'Create the fashion accessories'
  task create: :environment do
    PaperTrail.enabled = false

    puts 'Creating fashion accessories'

    count = Fashion.count
    fashions = %w(en de fr ja).each_with_object({}) do |locale, h|
      XIVData.sheet('Ornament', locale: locale).each do |fashion|
        next unless fashion['Singular'].present?
        next if Fashion.facewear_ids.include?(fashion['#'].to_i)

        icon = XIVData.format_icon_id(fashion['Icon'])

        data = h[fashion['#']] || { id: fashion['#'], order: fashion['Order'],
                                    icon: icon, icon_large: icon.sub(/^008/, '067') }

        data["name_#{locale}"] = sanitize_name(fashion['Singular'], locale: locale)
        h[data[:id]] = data
      end
    end

    fashions.values.each do |fashion|
      create_image(fashion[:id], XIVData.image_path(fashion.delete(:icon)), 'fashions/small')
      create_image(fashion[:id], XIVData.image_path(fashion.delete(:icon_large)), 'fashions/large')

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
