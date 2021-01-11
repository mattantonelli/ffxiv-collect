CRAFTERS = ['Carpenter', 'Blacksmith', 'Armorer', 'Goldsmith', 'Leatherworker', 'Weaver', 'Alchemist', 'Culinarian'].freeze

namespace :items do
  desc 'Create the items'
  task create: :environment do
    puts 'Creating items'
    count = Item.count

    items = XIVData.sheet('Item', locale: 'en').each_with_object({}) do |item, h|
      next unless item['Name'].present?

      icon_id = item['Icon'].sub(/.*?(\d+)\.tex/, '\1')
      tradeable = item['ItemSearchCategory'].present?

      data = { id: item['#'], name_en: sanitize_name(item['Name']), description_en: sanitize_text(item['Description']),
               icon_id: icon_id, tradeable: tradeable }

      h[data[:id]] = data
    end

    %w(de fr ja).each do |locale|
      XIVData.sheet('Item', locale: locale).each do |item|
        next unless item['Name'].present?

        items[item['#']].merge!("name_#{locale}" => sanitize_name(item['Name']),
                                "description_#{locale}" => sanitize_text(item['Description']))
      end
    end

    XIVData.sheet('Recipe', raw: true).each do |recipe|
      next unless items.has_key?(recipe['Item{Result}'])
      item = items[recipe['Item{Result}']]
      item.merge!(crafter: CRAFTERS[recipe['CraftType'].to_i], recipe_id: recipe['#'])
    end

    items.values.each do |item|
      if existing = Item.find_by(id: item[:id])
        existing.update!(item) if updated?(existing, item)
      else
        Item.create!(item)
      end
    end

    puts "Created #{Item.count - count} new items"
  end

  desc 'Sets collectable unlocks for items'
  task set_unlocks: :environment do
    PaperTrail.enabled = false
    puts 'Setting collectable unlocks for items'

    items = XIVData.sheet('Item', locale: 'en').each_with_object({}) do |item, h|
      next unless item['Name'].present? && item['ItemAction'] != 'ItemAction#0'

      action_id = XIVData.related_id(item['ItemAction'])
      h[action_id] = { id: item['#'], name_en: sanitize_name(item['Name']) }
    end

    XIVData.sheet('ItemAction', raw: true).each do |action|
      next unless data = items[action['#']]

      unlock_type = case action['Type']
                    when '1322' then 'Mount'
                    when '853'  then 'Minion'
                    when '5845' then 'Orchestrion'
                    when '1013' then 'Barding'
                    when '20086' then 'Fashion'
                    when '2633'
                      if data[:name_en].match?('Modern Aesthetics')
                        'Hairstyle'
                      elsif data[:name_en].match?('Ballroom Etiquette')
                        'Emote'
                      else
                        next
                      end
                    else
                      next
                    end

      unlock_class = unlock_type.constantize
      item = Item.find(data[:id])

      (0..9).each do |i|
        data = action["Data[#{i}]"]

        if data != '0' && collectable = unlock_class.find_by(id: data)
          # Set the item unlock data
          item.update!(unlock_type: unlock_type, unlock_id: data)

          # Set the collectable's item ID if the item is tradeable
          collectable.update!(item_id: item.id) if item.tradeable?
          break
        end
      end
    end
  end

  desc 'Sets extra data for collectables based on item unlocks'
  task set_extras: :environment do
    PaperTrail.enabled = false
    puts 'Setting extra data for collectables based on item unlocks'

    Item.where(unlock_type: 'Barding').each do |item|
      Barding.find(item.unlock_id).update!(item.slice(:name_en, :name_de, :name_fr, :name_ja,
                                                      :description_en, :description_de, :description_fr, :description_ja))
    end

    Item.where(unlock_type: 'Fashion').each do |item|
      Fashion.find(item.unlock_id).update!(item.slice(:description_en, :description_de, :description_fr, :description_ja))
    end
  end
end
