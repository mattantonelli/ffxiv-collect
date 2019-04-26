MOUNT_COLUMNS = %w(ID Description_* DescriptionEnhanced_* Icon IconSmall IconID IsFlying Name_* Order Tooltip_* GamePatch.Version).freeze

namespace :mounts do
  desc 'Create the mounts'
  task create: :environment do
    puts 'Creating mounts'
    count = Mount.count

    XIVAPI_CLIENT.search(indexes: 'Mount', columns: MOUNT_COLUMNS, filters: 'Order>=0', limit: 1000).each do |mount|
      data = { id: mount.id, flying: mount.flying == 1, order: mount.order, patch: mount.game_patch.version }

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
        existing.update!(data) if updated?(existing, data.symbolize_keys)
      else
        Mount.create!(data)
      end
    end

    create_spritesheet(Mount, 'mounts/large', 'mounts/large.png', 192, 192)
    create_spritesheet(Mount, 'mounts/small', 'mounts/small.png', 40, 40)
    create_spritesheet(Mount, 'mounts/footprint', 'mounts/footprint.png', 128, 128)

    puts "Created #{Mount.count - count} new mounts"
  end
end
