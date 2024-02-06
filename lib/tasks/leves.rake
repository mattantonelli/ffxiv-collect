require 'xiv_data'

namespace :leves do
  desc 'Create the Leves'
  task create: :environment do
    PaperTrail.enabled = false

    puts 'Creating Leves'
    count = Leve.count

    leves = %w(en de fr ja).each_with_object({}) do |locale, h|
      # Initialize the leves
      XIVData.sheet('Leve', locale: locale).each do |leve|
        next unless leve['Name'].present?

        unless data = h[leve['#']]
          category = leve['LeveAssignmentType']

          category = 'General' if category == 'Battlecraft' # Override category name for non GC Battle leves

          # Set the craft name based on the leve's category
          craft = case category
                 when /General|The Maelstrom|Order of the Twin Adder|Immortal Flames/
                   'Battlecraft'
                 when /Carpenter|Blacksmith|Armorer|Goldsmith|Leatherworker|Weaver|Alchemist|Culinarian/
                   'Tradecraft'
                 when /Miner|Botanist|Fisher/
                   'Fieldcraft'
                 end

          data = { id: leve['#'], craft: craft, category: category, level: leve['ClassJobLevel'],
                   location: XIVData.related_id(leve['Level{Levemete}']) }
        end

        data["name_#{locale}"] = sanitize_name(leve['Name'])

        h[data[:id]] = data
      end
    end

    # Delete unobtainable leves
    [
      546, 556, 566, # Introductory
      502, 519, 542, 544, # No longer available
      508, 514, 525, 531, 552, 554, 562, 564, 582, 597, 822, 827, 832 # Unimplemented
    ].each do |id|
      leves.delete(id.to_s)
    end

    # Add item ID and quantity for deliverable leves
    XIVData.sheet('CraftLeve', raw: true).each do |leve|
      next if leve['Leve'] == '0'

      quantity = (0..2).sum { |i| leve["ItemCount[#{i}]"].to_i }
      leves[leve['Leve']].merge!(item_id: leve['Item[0]'], item_quantity: quantity)
    end

    # Add location data
    level_ids = leves.values.pluck(:location).uniq
    XIVData.sheet('Level', raw: true).each do |level|
      if level_ids.include?(level['#'])
        # Compile the level data
        data = { issuer_x: level['X'].to_f, issuer_y: level['Z'].to_f,
                 map_id: level['Map'], npc_id: level['Object'] }

        # And assign it to each leve for the given location
        leves.values.select { |leve| leve[:location] == level['#'] }.each do |leve|
          leve.merge!(data)
          leve.delete(:location)
        end
      end
    end

    map_ids = leves.values.pluck(:map_id).uniq
    maps = maps_with_locations(map_ids)

    leves.values.each do |leve|
      map = maps[leve.delete(:map_id)]
      leve[:location_id] = map[:location_id]
      leve[:issuer_x] = get_coordinate(leve[:issuer_x], map[:x_offset], map[:size_factor])
      leve[:issuer_y] = get_coordinate(leve[:issuer_y], map[:y_offset], map[:size_factor])
    end


    # Add NPC issuer names
    npc_ids = leves.values.pluck(:npc_id).uniq
    npcs = %w(en fr de ja).each_with_object(Hash.new { |h, k| h[k] = {} }) do |locale, h|
      XIVData.sheet('ENpcResident', locale: locale).each do |npc|
        if npc_ids.include?(npc['#'])
          h[npc['#']]["issuer_name_#{locale}"] = sanitize_name(npc['Singular'])
        end
      end
    end

    leves.values.each do |leve|
      leve.merge!(npcs[leve.delete(:npc_id)])
    end

    leves.values.each do |leve|
      if existing = Leve.find_by(id: leve[:id])
        existing.update!(leve) if updated?(existing, leve)
      else
        Leve.create!(leve)
      end
    end

    puts "Created #{Leve.count - count} new leves"
  end
end
