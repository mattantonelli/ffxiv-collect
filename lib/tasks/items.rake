require 'xiv_data'

namespace :items do
  desc 'Create the items'
  task create: :environment do
    puts 'Creating items'
    count = Item.count

    actions = XIVData.sheet('ItemAction', raw: true).each_with_object({}) do |action, h|
      unlock_id = action['Data[0]']

      if unlock_id > '0'
        unlock_type = case action['Type']
                      when '1322' then 'mount'
                      when '853'  then 'minion'
                      when '5845' then 'orchestrion'
                      when '1013' then 'barding'
                      when '20086' then 'fashion'
                      when '2633' then 'other'
                      end

        if unlock_type.present?
          h[action['#']] = { unlock_type: unlock_type, unlock_id: unlock_id } if unlock_type.present?
        end
      end
    end

    items = XIVData.sheet('Item', locale: 'en').each_with_object({}) do |item, h|
      next unless item['Name'].present?

      icon_id = item['Icon'].sub(/.*?(\d+)\.tex/, '\1')
      tradeable = item['ItemSearchCategory'].present?

      data = { id: item['#'], name_en: sanitize_name(item['Name']), description_en: sanitize_text(item['Description']),
               icon_id: icon_id, tradeable: tradeable }

      unless item['ItemAction'] == 'ItemAction#0'
        action_id = XIVData.related_id(item['ItemAction'])

        if actions.has_key?(action_id)
          data.merge!(actions[action_id])

          if data[:unlock_type] == 'other'
            if data[:name_en].match?('Modern Aesthetics')
              data[:unlock_type] = 'hairstyle'
            elsif data[:name_en].match?('Ballroom Etiquette')
              data[:unlock_type] = 'emote'
            else
              data.merge!(unlock_type: nil, unlock_id: nil)
            end
          end
        end
      end

      h[data[:id]] = data
    end

    %w(de fr ja).each do |locale|
      XIVData.sheet('Item', locale: locale).each do |item|
        next unless item['Name'].present?

        items[item['#']].merge!("name_#{locale}" => sanitize_name(item['Name']),
                                "description_#{locale}" => sanitize_text(item['Description']))
      end
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
end
