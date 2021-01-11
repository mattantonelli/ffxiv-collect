namespace :armoires do
  desc 'Create the armoire items'
  task create: :environment do
    PaperTrail.enabled = false

    puts 'Creating armoire items'

    categories = XIVData.sheet('CabinetCategory', raw: true).map do |category|
      next if category['MenuOrder'] == '0'
      { id: category['#'], name: category['Category'], order: category['MenuOrder'] }
    end

    # The names are actually IDs referencing addon, so we need to look them up
    category_name_ids = categories.compact!.map { |category| category[:name] }

    category_names = %w(en de fr ja).each_with_object({}) do |locale, h|
      XIVData.sheet('Addon', locale: locale).each do |addon|
        if category_name_ids.include?(addon['#'])
          data = h[addon['#']] || {}
          h[addon['#']] = data.merge("name_#{locale}" => addon['Text'])
        end
      end
    end

    categories.each do |category|
      names = category_names[category.delete(:name)]
      ArmoireCategory.find_or_create_by!(category.merge(names))
    end

    count = Armoire.count
    ACHIEVEMENT_TYPE = SourceType.find_by(name: 'Achievement').freeze

    XIVData.sheet('Cabinet', raw: true, drop_zero: false).map do |armoire|
      next if armoire['Order'] == '0'

      item = Item.find_by(id: armoire['Item'])
      next unless item.present?

      data = { id: (armoire['#'].to_i + 1).to_s, category_id: armoire['Category'], order: armoire['Order'] }

      data[:gender] = case item.description_en
                      when /♂/ then 'male'
                      when /♀/ then 'female'
                      end

      data.merge!(item.slice(:name_en, :name_de, :name_fr, :name_ja,
                             :description_en, :description_de, :description_fr, :description_ja))

      create_image(data[:id], XIVData.icon_path(item.icon_id), 'armoires')

      if existing = Armoire.find_by(id: data[:id])
        existing.update!(data) if updated?(existing, data)
      else
        created = Armoire.create!(data)

        # Automatically create Achievement sources for new Armoire items
        if achievement = Achievement.find_by(item_id: armoire['Item'])
          created.sources.create!(type: ACHIEVEMENT_TYPE, text: achievement.name_en,
                                  related_type: 'Achievement', related_id: achievement.id)
        end
      end
    end

    create_spritesheet('armoires')

    puts "Created #{Armoire.count - count} new armoire items"
  end
end
