COMMON_MUSIC_IDS = [62, 107, 113, 121, 319, 895].freeze

namespace :mounts do
  desc 'Create the mounts'
  task create: :environment do
    PaperTrail.enabled = false

    puts 'Creating mounts'
    count = Mount.count

    mounts = %w(en de fr ja).each_with_object({}) do |locale, h|
      XIVData.sheet('Mount', locale: locale).each do |mount|
        next unless mount['Order'].to_i >= 0 && mount['Singular'].present?

        data = h[mount['#']] || { id: mount['#'], order: mount['Order'], order_group: mount['UIPriority'],
                                  seats: (mount['ExtraSeats'].to_i + 1).to_s, icon: XIVData.format_icon_id(mount['Icon']),
                                  movement: mount['IsAirborne'] == 'True' ? 'Airborne' : 'Terrestrial',
                                  custom_music: !COMMON_MUSIC_IDS.include?(mount['RideBGM'].to_i) }
        data["name_#{locale}"] = sanitize_name(mount['Singular'], locale: locale, capitalize: true)

        h[data[:id]] = data
      end
    end

    # Add the remaining data from the transient sheet
    %w(en de fr ja).each do |locale, h|
      XIVData.sheet('MountTransient', locale: locale).each do |mount|
        next unless mounts.has_key?(mount['#'])

        data = mounts[mount['#']]
        data.merge!("description_#{locale}" => sanitize_text(mount['Description']),
                    "enhanced_description_#{locale}" => sanitize_text(mount['DescriptionEnhanced']),
                    "tooltip_#{locale}" => sanitize_text(mount['Tooltip']))
      end
    end

    mounts.values.each do |mount|
      large_icon = mount[:icon].sub(/^004/, '068')
      footprint_icon = mount[:icon].sub(/^004/, '069')

      create_image(mount[:id], XIVData.image_path(large_icon), 'mounts/large')
      create_image(mount[:id], XIVData.image_path(mount.delete(:icon)), 'mounts/small')
      create_image(mount[:id], XIVData.image_path(footprint_icon), 'mounts/footprint', mask_from: '#151515ff')

      if existing = Mount.find_by(id: mount[:id])
        existing.update!(mount) if updated?(existing, mount)
      else
        Mount.create!(mount)
      end
    end

    create_spritesheet('mounts/small')

    puts "Created #{Mount.count - count} new mounts"
  end
end
