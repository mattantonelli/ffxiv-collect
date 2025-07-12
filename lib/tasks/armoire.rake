namespace :armoires do
  desc 'Create the armoire items'
  task create: :environment do
    PaperTrail.enabled = false

    puts 'Creating armoire items'

    categories = XIVData.sheet('CabinetCategory').filter_map do |category|
      next if category['MenuOrder'] == '0'
      { id: category['#'], name: category['Category'], order: category['MenuOrder'] }
    end

    # The names are actually IDs referencing addon, so we need to look them up
    category_name_ids = categories.map { |category| category[:name] }

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
    ACHIEVEMENT_TYPE = SourceType.find_by(name_en: 'Achievement').freeze
    PREMIUM_TYPE = SourceType.find_by(name_en: 'Premium').freeze
    PREMIUM_CATEGORIES = ArmoireCategory.where(name_en: %w(Costumes Fashions Mascots)).pluck(:id)

    XIVData.sheet('Cabinet').map do |armoire|
      next if armoire['Order'] == '0'

      item = Item.find_by(id: armoire['Item'])
      next unless item.present?

      data = { id: (armoire['#'].to_i + 1).to_s, category_id: armoire['Category'],
               order: armoire['Order'], order_group: armoire['SubCategory'], item_id: item.id.to_s }

      data[:gender] = case item.description_en
                      when /♂/ then 'male'
                      when /♀/ then 'female'
                      end

      data.merge!(item.slice(:name_en, :name_de, :name_fr, :name_ja,
                             :description_en, :description_de, :description_fr, :description_ja))

      # Update the Item to indicate that it unlocks this Armoire
      item.update!(unlock_type: 'Armoire', unlock_id: data[:id])

      create_image(data[:id], XIVData.image_path(item.icon_id), 'armoires')

      if existing = Armoire.find_by(id: data[:id])
        existing.update!(data) if updated?(existing, data)
      else
        created = Armoire.create!(data)

        # Automatically create Achievement sources for new Armoire items
        if achievement = Achievement.find_by(item_id: armoire['Item'])
          texts = %w(en de fr ja).each_with_object({}) do |locale, h|
            h["text_#{locale}"] = achievement["name_#{locale}"]
          end

          created.sources.create!(**texts, type: ACHIEVEMENT_TYPE, related_type: 'Achievement', related_id: achievement.id)
        elsif PREMIUM_CATEGORIES.include?(armoire['Category'].to_i)
          texts = %w(en de fr ja).each_with_object({}) do |locale, h|
            h["text_#{locale}"] = I18n.t('sources.online_store', locale: locale)
          end

          created.sources.create!(**texts, type: PREMIUM_TYPE, premium: true)
        end
      end
    end

    create_spritesheet('armoires')

    puts "Created #{Armoire.count - count} new armoire items"
  end
end
