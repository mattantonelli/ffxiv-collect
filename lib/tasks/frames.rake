namespace :frames do
  desc "Create the framer's kits"
  task create: :environment do
    PaperTrail.enabled = false

    puts "Creating framer's kits"

    frames = XIVData.sheet('BannerCondition', raw: true).each_with_object({}) do |frame, h|
      if frame['UnlockType1'] == '9'
        h[frame['#']] = { id: frame['#'], item_link: frame['UnlockCriteria1[0]'] }
      elsif frame['UnlockType1'] == '11'
        # For type 11, we need to assign the last non-zero value since the condition
        # can be unlocked by multiple items (e.g. Bronze-Crystal Framer's Kit)
        6.times do |i|
          item_link = frame["UnlockCriteria1[#{5 - i}]"]

          if item_link != '0'
            h[frame['#']] = { id: frame['#'], item_link: item_link }
            break
          end
        end
      end
    end

    # Links Item AdditionalData to Frame ID so they can be looked up from Item
    frame_links = frames.each_with_object({}) do |(key, frame), h|
      h[frame.delete(:item_link)] = frame[:id]
    end

    %w(en de fr ja).each do |locale|
      XIVData.sheet('BannerBg', locale: locale).each do |bg|
        id = XIVData.related_id(bg['UnlockCondition'])

        if frames.key?(id)
          frames[id]["name_#{locale}"] = sanitize_name(bg['Name'])
        end
      end
    end

    XIVData.sheet('Item', raw: true).each do |item|
      if item['ItemAction'] == '2234'
        frame = frames[frame_links[item['AdditionalData']]]

        frame[:item_id] = item['#']
        Item.find(item['#']).update!(unlock_type: 'Frame', unlock_id: frame[:id])
      end
    end

    count = Frame.count
    PVP_TYPE = SourceType.find_by(name: 'PvP').freeze

    frames.values.each do |frame|
      if existing = Frame.find_by(id: frame[:id])
        existing.update!(frame) if updated?(existing, frame)
      else
        created = Frame.create!(frame)

        if frame['name_en'].match?(/Conflict \d+/)
          created.sources.create!(type: PVP_TYPE, text: 'Crystalline Conflict Season Reward', limited: true)
        end
      end
    end

    puts "Created #{Frame.count - count} new framer's kits"
  end
end
