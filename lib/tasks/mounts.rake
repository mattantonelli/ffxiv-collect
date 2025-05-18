namespace :mounts do
  desc 'Create the mounts'
  task create: :environment do
    PaperTrail.enabled = false

    puts 'Creating mounts'
    count = Mount.count

    fields = %w(
      Singular@i18n Order UIPriority ExtraSeats Icon IsAirborne RideBGM
    )

    transient = %w(
      Description@i18n DescriptionEnhanced@i18n Tooltip@i18n
    )

    mounts = XIVAPI.sheet('Mount', fields: fields, transient: transient).each_with_object({}) do |mount, h|
      next unless mount['Order'] >= 0 && mount['Singular@lang(en)'].present?

      data = {
        id: mount['#'], order: mount['Order'], order_group: mount['UIPriority'],
        seats: mount['ExtraSeats'].to_i + 1, icon: mount.dig('Icon', 'path'),
        movement: mount['IsAirborne'] ? 'Airborne' : 'Terrestrial'
      }

      data.merge!(XIVAPI.translate(mount, 'Singular', 'name'))
      data.merge!(XIVAPI.translate(mount, 'Description', 'description', type: :text))
      data.merge!(XIVAPI.translate(mount, 'DescriptionEnhanced', 'enhanced_description', type: :text))
      data.merge!(XIVAPI.translate(mount, 'Tooltip', 'tooltip', type: :text))

      bgm = mount['RideBGM'].dig('fields', 'File')
      unless bgm&.match?(/(Ride_Chocobo|Common|FlyingMount)/)
        data[:bgm_sample] = bgm
      end

      h[data[:id]] = data
    end

    mounts.values.each do |mount|
      large_icon = mount[:icon].gsub('/004', '/068')
      icon_id = mount[:icon].sub(/.+?(\d+)\.tex/, '\1').to_i
      footprint_icon = XIVAPI.asset_path(65000 + icon_id)

      create_image(mount[:id], large_icon, 'mounts/large')
      create_image(mount[:id], mount.delete(:icon), 'mounts/small')
      create_image(mount[:id], footprint_icon, 'mounts/footprint', mask_from: '#151515ff')

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
