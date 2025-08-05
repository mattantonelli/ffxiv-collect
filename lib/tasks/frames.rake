namespace :frames do
  desc "Create the framer's kits"
  task create: :environment do
    PaperTrail.enabled = false

    puts "Creating framer's kits"

    # Create frames only when a BannerBg is present. This should include all Framer's Kits
    # and quest/instance unlocks. It will ignore clutter like minion accents.
    frames = XIVData.sheet('BannerBg', locale: 'en').each_with_object({}) do |bg, h|
      id = bg['UnlockCondition']
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
        id = bg['UnlockCondition']

        if frames.key?(id)
          frames[id]["name_#{locale}"] = sanitize_name(bg['Name'])
        end
      end
    end

    XIVData.sheet('BannerCondition').each do |condition|
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
      # when '11'
        # Crystalline Conflict Seasonal Rewards
        # These don't properly link to items any more
      end
    end

    # Links Item AdditionalData to Frame ID so they can be looked up from Item
    frame_links = frames.each_with_object({}) do |(key, frame), h|
      if frame.key?(:item_link)
        h[frame.delete(:item_link)] = frame[:id]
      end
    end

    XIVData.sheet('Item').each do |item|
      if item['ItemAction'] == '2234'
        frame = frames[frame_links[item['AdditionalData']]]

        # Skip items that can't be linked back to a frame (should just be for type 11 above)
        next if frame.nil?

        frame[:item_id] = item['#']
        Item.find(item['#']).update!(unlock_type: 'Frame', unlock_id: frame[:id])
      end
    end

    count = Frame.count
    PVP_TYPE = SourceType.find_by(name_en: 'PvP').freeze
    QUEST_TYPE = SourceType.find_by(name_en: 'Quest').freeze

    frames.values.each do |frame|
      data = frame.except(:unlock_type, :unlock_id)

      # Remove item linkages for Crystalline Conflict seasonal rewards since they got messed up
      data[:item_id] = nil if frame['name_en'].match?(/.+ Conflict \d+/)

      if existing = Frame.find_by(id: frame[:id])
        existing.update!(data) if updated?(existing, data)
      else
        created = Frame.create!(data)

        if frame['name_en'].match?(/Conflict \d+/)
          texts = %w(en de fr ja).each_with_object({}) do |locale, h|
            h["text_#{locale}"] = I18n.t('sources.crystalline_conflict', locale: locale)
          end

          created.sources.create!(**texts, type: PVP_TYPE, limited: true)
        elsif frame[:unlock_type] == 'Quest'
          texts = %w(en de fr ja).each_with_object({}) do |locale, h|
            h["text_#{locale}"] = Quest.find(frame[:unlock_id])["name_#{locale}"]
          end

          created.sources.create!(**texts, type: QUEST_TYPE, related_type: 'Quest',
                                  related_id: frame[:unlock_id])
        elsif frame[:unlock_type] == 'Instance'
          instance = Instance.find(frame[:unlock_id])
          instance_type = instance.content_type.name_en

          texts = %w(en de fr ja).each_with_object({}) do |locale, h|
            h["text_#{locale}"] = instance["name_#{locale}"]
          end

          created.sources.create!(**texts, type: SourceType.find_by(name_en: instance_type),
                                  related_type: 'Instance', related_id: frame[:unlock_id])
        end
      end
    end

    puts "Created #{Frame.count - count} new framer's kits"

    return unless Dir.exist?(XIVData::IMAGE_PATH)

    puts "Creating framer's kit images"

    frames.each { |k, _| frames[k] = {} }

    XIVData.sheet('CharaCardBase', locale: 'en').each do |component|
      id = component['UnlockCondition']

      if frames.key?(id)
        frames[id][:base] = XIVData.image_path(component['Image'])
      end
    end

    XIVData.sheet('CharaCardDecoration', locale: 'en').each do |component|
      id = component['UnlockCondition']

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
        id = component['UnlockCondition']

        if frames.key?(id)
          frames[id][key] = XIVData.image_path(component['Image'])
        end
      end
    end

    XIVData.sheet('CharaCardHeader', locale: 'en').each do |component|
      id = component['UnlockCondition']

      if frames.key?(id)
        frames[id][:top_border] = XIVData.image_path(component['TopImage']) if component['TopImage'] != '0'
        frames[id][:bottom_border] = XIVData.image_path(component['BottomImage']) if component['BottomImage'] != '0'
      end
    end

    FRAME_IMAGES_DIR = Rails.root.join('public/images/frames').freeze
    FRAME_ELEMENTS = %i(base backing overlay plate_frame).freeze

    frames.each do |id, images|
      output_path = FRAME_IMAGES_DIR.join("#{id}.png")

      unless output_path.exist?
        frame = Frame.find(id)
        frame.update!(portrait_only: !images.keys.intersect?(FRAME_ELEMENTS))

        begin
          # Download BLOBs for each image layer
          layers = images.each_with_object({}) do |(k, image), h|
            h[k] = XIVData.download_image(image).body
          end

          if frame.portrait_only?
            image = ChunkyPNG::Image.new(256, 420, ChunkyPNG::Color::TRANSPARENT)

            layers.values.each do |layer|
              image.compose!(ChunkyPNG::Image.from_blob(layer))
            end

            image.save(output_path)
          else
            # Create two frame versions to support standard and mirrored portraits
            save_frame_image(layers, output_path)
            save_frame_image(layers, output_path, mirrored: true)
          end
        rescue StandardError
          puts "Could not create image: #{output_path}"
        end
      end
    end
  end

  def save_frame_image(layers, output_path, mirrored: false)
    if mirrored
      portrait_x = 302
      path = output_path.to_s.sub('.png', '_2.png')
    else
      portrait_x = 722
      path = output_path.to_s
    end

    image = ChunkyPNG::Image.new(1280, 806, ChunkyPNG::Color::TRANSPARENT)

    image.compose!(ChunkyPNG::Image.from_blob(layers[:backing]), 0, 0) if layers.key?(:backing)
    image.compose!(ChunkyPNG::Image.from_blob(layers[:base]), 270, 150) if layers.key?(:base)
    image.compose!(ChunkyPNG::Image.from_blob(layers[:overlay]), 270, 150) if layers.key?(:overlay)
    image.compose!(ChunkyPNG::Image.from_blob(layers[:background]), portrait_x, 150) if layers.key?(:background)
    image.compose!(ChunkyPNG::Image.from_blob(layers[:portrait_frame]), portrait_x, 150) if layers.key?(:portrait_frame)
    image.compose!(ChunkyPNG::Image.from_blob(layers[:portrait_accent]), portrait_x, 150) if layers.key?(:portrait_accent)
    image.compose!(ChunkyPNG::Image.from_blob(layers[:plate_portrait]), portrait_x - 96, 0) if layers.key?(:plate_portrait)
    image.compose!(ChunkyPNG::Image.from_blob(layers[:plate_frame]), 160, 86) if layers.key?(:plate_frame)
    image.compose!(ChunkyPNG::Image.from_blob(layers[:top_border]), 160, 86) if layers.key?(:top_border)
    image.compose!(ChunkyPNG::Image.from_blob(layers[:bottom_border]), 160, 478) if layers.key?(:bottom_border)
    image.compose!(ChunkyPNG::Image.from_blob(layers[:accent]), mirrored ? portrait_x - 128 : portrait_x + 131, 380) if layers.key?(:accent)

    image.trim!
    image.save(path)
  end
end
