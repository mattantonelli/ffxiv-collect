namespace :outfits do
  desc 'Create the outfits'
  task create: :environment do
    PaperTrail.enabled = false

    puts 'Creating outfits'

    count = Outfit.count

    XIVData.sheet('MirageStoreSetItem').each do |outfit|
      next if outfit['#'] == '0'

      item_ids = outfit
        .values_at('MainHand', 'OffHand', 'Head', 'Body', 'Hands', 'Legs', 'Feet', 'Earrings', 'Necklace', 'Bracelets', 'Ring')
        .reject { |id| id == '0' }
        .map(&:to_i)

      next if item_ids.empty?

      item = Item.find(outfit['#'])

      data = { id: outfit['#'], item_ids: item_ids, gender: nil,
               armoireable: Armoire.exists?(item_id: item_ids.first),
               name_en: item.name_en, name_de: item.name_de, name_fr: item.name_fr, name_ja: item.name_ja }

      # Check the associated items for tradeability and gender restrictions
      Item.where(id: item_ids).each do |item|
        data[:item_id] = outfit['#'] if item.tradeable?

        gender = case item.description_en
                 when /♂/ then 'male'
                 when /♀/ then 'female'
                 end

        if gender != nil
          data[:gender] = gender
          break
        end
      end

      create_image(outfit['#'], XIVData.image_path(item.icon_id), 'outfits')

      if existing = Outfit.find_by(id: data[:id])
        existing.update!(data) if updated?(existing, data)
      else
        created = Outfit.create!(data)

        if created.armoireable?
          Armoire.find_by(item_id: created.item_ids.first).sources.each do |source|
            created.sources.create!(source.slice(:text_en, :text_de, :text_fr, :text_ja, :premium, :limited,
                                                 :type_id, :related_id, :related_type))
          end
        end
      end
    end

    # Create images for outfit items
    Item.joins(:outfit_items).distinct.each do |item|
      create_image(item.id, XIVData.image_path(item.icon_id), 'outfit_items')
    end

    create_spritesheet('outfits')
    create_spritesheet('outfit_items')

    puts "Created #{Outfit.count - count} new outfits"
  end
end
