HAIRSTYLE_COLUMNS = %w(Name_* Description_* GamePatch.Version ItemAction.Data0).freeze

namespace :hairstyles do
  desc 'Create the hairstyles'
  task create: :environment do
    puts 'Creating hairstyles'

    count = Hairstyle.count
    XIVAPI_CLIENT.search(indexes: 'Item', columns: HAIRSTYLE_COLUMNS, string: 'modern aesthetics -').each do |hairstyle|
      data = { id: hairstyle.item_action.data0, patch: hairstyle.game_patch.version }

      %w(en de fr ja).each do |locale|
        data["name_#{locale}"] = sanitize_name(hairstyle["name_#{locale}"])
          .gsub(/.*(?:- |:|“(?=\w))(.*)/, '\1')
          .delete('“”')

        data["description_#{locale}"] = sanitize_text(hairstyle["description_#{locale}"])
      end

      if existing = Hairstyle.find_by(id: data[:id])
        data = without_names(data)
        existing.update!(data) if updated?(existing, data.symbolize_keys)
      else
        Hairstyle.create!(data)
      end
    end

    Hairstyle.find_or_create_by!(id: 228, patch: '2.4', name_en: 'Eternal Bonding', name_de: 'Eternal Bonding',
                                 name_fr: 'Eternal Bonding', name_ja: 'Eternal Bonding')

    XIVAPI_CLIENT.content(name: 'CharaMakeCustomize', columns: %w(Data Icon), limit: 10000).each do |custom|
      next if custom.data == 0
      path = Rails.root.join('public/images/hairstyles', custom.data.to_s)
      Dir.mkdir(path) unless Dir.exist?(path)
      download_image(nil, custom.icon, path.join("#{custom.icon.scan(/\d+\.png/).first}"))
    end

    Hairstyle.all.each do |hairstyle|
      sheet = ChunkyPNG::Image.new(96 * 14, 96)

      Dir.glob(Rails.root.join('public/images/hairstyles', hairstyle.id.to_s, '*.png')).sort.each_with_index do |image, i|
        sheet.compose!(ChunkyPNG::Image.from_file(image), 96 * i, 0)
      end

      sheet.save(Rails.root.join('app/assets/images/hairstyles', "#{hairstyle.id}.png").to_s)
    end

    puts "Created #{Hairstyle.count - count} new hairstyles"
  end
end
