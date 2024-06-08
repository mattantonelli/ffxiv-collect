namespace :frames do
  desc "Create the framer's kits"
  task create: :environment do
    PaperTrail.enabled = false

    puts "Creating framer's kits"

    # Create frames only when a BannerBg is present. This should include all Framer's Kits
    # and quest/instance unlocks. It will ignore clutter like minion accents.
    frames = XIVData.sheet('BannerBg', locale: 'en').each_with_object({}) do |bg, h|
      id = XIVData.related_id(bg['UnlockCondition'])
      next if id == '0' || id == '1'

      h[id] = { id: id, order: bg['SortKey'], 'name_en' => sanitize_name(bg['Name']) }
    end

    # Add Tataru's Bespoke kit which lacks a BannerBg
    frames['573'] = { id: '573', order: '0',
                    'name_en' => "Tataru's Bespoke",
                    'name_de' => 'Tatarus Wohlstandsmanufaktur',
                    'name_fr' => 'La Tarufacture de Tataru',
                    'name_ja' => 'タタルの大繁盛商店' }

    # Act like the township frames don't exist because they don't have unique BannerCondition IDs
    frames.delete('299')
    frames.delete('346')

    %w(de fr ja).each do |locale|
      XIVData.sheet('BannerBg', locale: locale).each do |bg|
        id = XIVData.related_id(bg['UnlockCondition'])

        if frames.key?(id)
          frames[id]["name_#{locale}"] = sanitize_name(bg['Name'])
        end
      end
    end

    XIVData.sheet('BannerCondition', raw: true).each do |condition|
      next unless frame = frames[condition['#']]

      case condition['UnlockType1']
      when '1'
        frame.merge!(unlock_type: 'Quest', unlock_id: condition['UnlockCriteria1[0]'])
      when '4'
        frame.merge!(unlock_type: 'Instance', unlock_id: condition['UnlockCriteria1[0]'])
      # when '6'
      #   frame.merge!(unlock_type: 'Minion', unlock_id: condition['UnlockCriteria1[0]'])
      when '9'
        # For type 9, the criterion links to an item
        frame[:item_link] = condition['UnlockCriteria1[0]']
      when '11'
        # For type 11, the are multiple item links (e.g. Bronze-Crystal Framer's Kit)
        # and we need the last non-zero value to link to the primary item
        6.times do |i|
          item_link = condition["UnlockCriteria1[#{5 - i}]"]

          if item_link != '0'
            frame[:item_link] = item_link
            break
          end
        end
      end
    end

    # Links Item AdditionalData to Frame ID so they can be looked up from Item
    frame_links = frames.each_with_object({}) do |(key, frame), h|
      if frame.key?(:item_link)
        h[frame.delete(:item_link)] = frame[:id]
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
    PVP_TYPE = SourceType.find_by(name_en: 'PvP').freeze
    QUEST_TYPE = SourceType.find_by(name_en: 'Quest').freeze

    frames.values.each do |frame|
      data = frame.except(:unlock_type, :unlock_id)

      if existing = Frame.find_by(id: frame[:id])
        existing.update!(data) if updated?(existing, data)
      else
        created = Frame.create!(data)

        if frame['name_en'].match?(/Conflict \d+/)
          created.sources.create!(type: PVP_TYPE, text: 'Crystalline Conflict Season Reward', limited: true)
        elsif frame[:unlock_type] == 'Quest'
          created.sources.create!(type: QUEST_TYPE, text: Quest.find(frame[:unlock_id]).name_en,
                                  related_type: 'Quest', related_id: frame[:unlock_id])
        elsif frame[:unlock_type] == 'Instance'
          instance = Instance.find(frame[:unlock_id])
          instance_type = instance.content_type
          created.sources.create!(type: SourceType.find_by(name_en: instance_type), text: instance.name_en,
                                  related_type: instance_type, related_id: frame[:unlock_id])
        end
      end
    end

    puts "Created #{Frame.count - count} new framer's kits"

    return unless Dir.exist?(XIVData::IMAGE_PATH)

    puts "Creating framer's kit images"

    frames.each { |k, _| frames[k] = {} }

    XIVData.sheet('CharaCardBase', locale: 'en').each do |component|
      id = XIVData.related_id(component['UnlockCondition'])

      if frames.key?(id)
        frames[id][:base] = XIVData.image_path(component['Image'])
      end
    end

    XIVData.sheet('CharaCardDecoration', locale: 'en').each do |component|
      id = XIVData.related_id(component['UnlockCondition'])

      if frames.key?(id)
        key = case component['Category']
              when '1' then :backing
              when '2' then :overlay
              when '3' then :plate_portrait
              when '4' then :plate_frame
              when '5' then :accent
              end

        frames[id][key] = XIVData.image_path(component['Image'])
      end
    end

    { background: 'BannerBg', portrait_frame: 'BannerFrame', portrait_accent: 'BannerDecoration' }.each do |key, sheet|
      XIVData.sheet(sheet, locale: 'en').each do |component|
        id = XIVData.related_id(component['UnlockCondition'])

        if frames.key?(id)
          frames[id][key] = XIVData.image_path(component['Image'])
        end
      end
    end

    XIVData.sheet('CharaCardHeader', locale: 'en').each do |component|
      id = XIVData.related_id(component['UnlockCondition'])

      if frames.key?(id)
        frames[id][:top_border] = XIVData.image_path(component['TopImage']) if component['TopImage'].present?
        frames[id][:bottom_border] = XIVData.image_path(component['BottomImage']) if component['BottomImage'].present?
      end
    end

    FRAME_IMAGES_DIR = Rails.root.join('public/images/frames').freeze

    frames.each do |id, images|
      output_path = FRAME_IMAGES_DIR.join("#{id}.png")

      unless output_path.exist?
        begin
          if Frame.find(id).portrait_only?
            image = ChunkyPNG::Image.new(256, 420, ChunkyPNG::Color::TRANSPARENT)

            images.values.each do |layer|
              image.compose!(ChunkyPNG::Image.from_file(layer))
            end
          else
            image = ChunkyPNG::Image.new(1280, 806, ChunkyPNG::Color::TRANSPARENT)
            image.compose!(ChunkyPNG::Image.from_file(images[:backing]), 0, 0) if images.key?(:backing)
            image.compose!(ChunkyPNG::Image.from_file(images[:base]), 270, 150) if images.key?(:base)
            image.compose!(ChunkyPNG::Image.from_file(images[:overlay]), 270, 150) if images.key?(:overlay)
            image.compose!(ChunkyPNG::Image.from_file(images[:background]), 722, 150) if images.key?(:background)
            image.compose!(ChunkyPNG::Image.from_file(images[:plate_frame]), 160, 86) if images.key?(:plate_frame)
            image.compose!(ChunkyPNG::Image.from_file(images[:portrait_frame]), 722, 150) if images.key?(:portrait_frame)
            image.compose!(ChunkyPNG::Image.from_file(images[:portrait_accent]), 722, 150) if images.key?(:portrait_accent)
            image.compose!(ChunkyPNG::Image.from_file(images[:plate_portrait]), 630, 0) if images.key?(:plate_portrait)
            image.compose!(ChunkyPNG::Image.from_file(images[:top_border]), 160, 86) if images.key?(:top_border)
            image.compose!(ChunkyPNG::Image.from_file(images[:bottom_border]), 160, 478) if images.key?(:bottom_border)
            image.compose!(ChunkyPNG::Image.from_file(images[:accent]), 850, 380) if images.key?(:accent)
            image.trim!
          end

          image.save(output_path.to_s)
        rescue StandardError
          puts "Could not create image: #{output_path}"
        end
      end
    end
  end
end
