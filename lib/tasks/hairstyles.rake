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
        data = without_custom(data)
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

      filename = path.join("#{custom.icon.scan(/\d+\.png/).first}")
      download_image(nil, custom.icon, filename)

      # Use the first image as a sample of the hairstyle
      sample_filename = Rails.root.join('public/images/hairstyles/samples', "#{custom.data.to_s}.png")
      FileUtils.cp(filename, sample_filename) unless File.exists?(sample_filename)
    end

    create_hair_spritesheets

    puts "Created #{Hairstyle.count - count} new hairstyles"
  end
end
