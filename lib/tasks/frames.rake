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
        frames[id][:top_border] = XIVData.image_path(component['TopImage'])
        frames[id][:bottom_border] = XIVData.image_path(component['BottomImage'])
      end
    end

    IMAGES_DIR = Rails.root.join('public/images/frames').freeze

    frames.each do |id, images|
      output_path = IMAGES_DIR.join("#{id}.png")

      unless output_path.exist?
        begin
          if Frame.find(id).portrait_only?
            image = ChunkyPNG::Image.new(256, 420, ChunkyPNG::Color::TRANSPARENT)

            images.values.each do |layer|
              image.compose!(ChunkyPNG::Image.from_file(layer))
            end
          else
            image = ChunkyPNG::Image.new(960, 806, ChunkyPNG::Color::TRANSPARENT)
            image.compose!(ChunkyPNG::Image.from_file(images[:base]), 110, 150) if images.key?(:base)
            image.compose!(ChunkyPNG::Image.from_file(images[:overlay]), 110, 150) if images.key?(:overlay)
            image.compose!(ChunkyPNG::Image.from_file(images[:background]), 562, 150) if images.key?(:background)
            image.compose!(ChunkyPNG::Image.from_file(images[:plate_frame]), 0, 86) if images.key?(:plate_frame)
            image.compose!(ChunkyPNG::Image.from_file(images[:portrait_frame]), 562, 150) if images.key?(:portrait_frame)
            image.compose!(ChunkyPNG::Image.from_file(images[:portrait_accent]), 562, 150) if images.key?(:portrait_accent)
            image.compose!(ChunkyPNG::Image.from_file(images[:plate_portrait]), 470, 0) if images.key?(:plate_portrait)
            image.compose!(ChunkyPNG::Image.from_file(images[:top_border]), 0, 86) if images.key?(:top_border)
            image.compose!(ChunkyPNG::Image.from_file(images[:bottom_border]), 0, 478) if images.key?(:bottom_border)
            image.compose!(ChunkyPNG::Image.from_file(images[:accent]), 690, 380) if images.key?(:accent)
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
