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
                                  seats: (mount['ExtraSeats'].to_i + 1).to_s, icon: mount['Icon'],
                                  movement: mount['IsAirborne'] == 'True' ? 'Airborne' : 'Terrestrial'}
        data["name_#{locale}"] = sanitize_name(mount['Singular'])

        # Set unique BGM samples on the first pass
        unless h.has_key?(mount['#']) || mount['RideBGM'].match?(/(Ride_Chocobo|CommonMonster|FlyingMount)/)
          data[:bgm_sample] = XIVData.music_filename(mount['RideBGM'])
          link_music(XIVData.music_path(mount['RideBGM']))
        end

        h[data[:id]] = data
      end
    end

    # Add the remaining data from the transient sheet
    %w(en de fr ja).each do |locale, h|
      XIVData.sheet('MountTransient', locale: locale).each do |mount|
        next unless mounts.has_key?(mount['#'])

        data = mounts[mount['#']]
        data.merge!("description_#{locale}" => sanitize_text(mount['Description']),
                    "enhanced_description_#{locale}" => sanitize_text(mount['Description{Enhanced}']),
                    "tooltip_#{locale}" => sanitize_text(mount['Tooltip']))
      end
    end

    mounts.values.each do |mount|
      large_icon = mount[:icon].gsub('/004', '/068')
      icon_id = mount[:icon].sub(/.*?(\d+)\.tex/, '\1').to_i
      footprint_icon = XIVData.icon_path(65000 + icon_id)

      create_image(mount[:id], large_icon, 'mounts/large')
      create_image(mount[:id], mount.delete(:icon), 'mounts/small')
      create_image(mount[:id], footprint_icon, 'mounts/footprint', '#151515ff')

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
