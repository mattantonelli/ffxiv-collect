namespace :bardings do
  desc 'Create the bardings'
  task create: :environment do
    PaperTrail.enabled = false

    puts 'Creating bardings'

    count = Barding.count

    bardings = %w(en de fr ja).each_with_object({}) do |locale, h|
      XIVData.sheet('BuddyEquip', locale: locale).each do |barding|
        next unless barding['Name'].present?

        data = h[barding['#']] || { id: barding['#'], order: barding['Order'],
                                    icon: barding['Icon{Body}'].present? ? barding['Icon{Body}'] : barding['Icon{Head}'] }

        if item = Item.find_by(unlock_type: 'barding', unlock_id: data[:id])
          data.merge!(item.slice("name_#{locale}", "description_#{locale}"))
          data[:item_id] ||= item.id.to_s if item.tradeable
        else
          data["name_#{locale}"] = sanitize_name(barding['Name'])
        end

        h[data[:id]] = data
      end
    end

    bardings.values.each do |barding|
      create_image(barding[:id], barding.delete(:icon), 'bardings')

      if existing = Barding.find_by(id: barding[:id])
        existing.update!(barding) if updated?(existing, barding)
      else
        Barding.create!(barding)
      end
    end

    create_spritesheet('bardings')

    puts "Created #{Barding.count - count} new bardings"
  end
end
