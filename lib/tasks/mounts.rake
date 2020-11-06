MOUNT_COLUMNS = %w(ID Description_* DescriptionEnhanced_* Icon IconSmall IconID IsFlying Name_* Order
UIPriority Tooltip_* GamePatch.Version IsAirborne ExtraSeats).freeze

namespace :mounts do
  desc 'Create the mounts'
  task create: :environment do
    PaperTrail.enabled = false

    puts 'Creating mounts'
    count = Mount.count

    XIVAPI_CLIENT.search(indexes: 'Mount', columns: MOUNT_COLUMNS, filters: 'Order>=0', limit: 1000).each do |mount|
      data = { id: mount.id, flying: mount.is_flying != 0, order: mount.order, order_group: mount.uipriority,
               patch: mount.game_patch.version, movement: mount.is_airborne == 1 ? 'Airborne' : 'Terrestrial',
               seats: mount.extra_seats + 1 }

      %w(en de fr ja).each do |locale|
        data["name_#{locale}"] = sanitize_name(mount["name_#{locale}"])
        data["enhanced_description_#{locale}"] = sanitize_text(mount["description_enhanced_#{locale}"])

        %w(description tooltip).each do |field|
          data["#{field}_#{locale}"] = sanitize_text(mount["#{field}_#{locale}"])
        end
      end

      download_image(mount.id, mount.icon, 'mounts/large')
      download_image(mount.id, mount.icon_small, 'mounts/small')

      if mount.icon_id > 4500
        footprint_id = 78000 + mount.icon_id - 8000
        footprint_offset = '078000'
      else
        footprint_id = 69400 + mount.icon_id - 4400
        footprint_offset = '069000'
      end

      footprint_id = footprint_id.to_s.rjust(6, '0')
      download_image(mount.id, "/i/#{footprint_offset}/#{footprint_id}.png", 'mounts/footprint', '#151515ff')

      if existing = Mount.find_by(id: mount.id)
        data = data.symbolize_keys.except(:patch)
        existing.update!(data) if updated?(existing, data)
      else
        Mount.create!(data)
      end
    end

    create_spritesheet('mounts/small')

    puts "Created #{Mount.count - count} new mounts"
  end
end
