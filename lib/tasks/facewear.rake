namespace :facewear do
  desc 'Create the facewear'
  task create: :environment do
    PaperTrail.enabled = false

    puts 'Creating facewear'

    facewears = XIVData.sheet('GlassesStyle', locale: 'en').each_with_object({}) do |facewear, h|
      next unless facewear['Name'].present? && facewear['Icon'] != '0'

      id = (facewear['#'].to_i + 1).to_s

      h[id] = {
        id: id,
        name_en: sanitize_name(facewear['Name']),
        lodestone_name: sanitize_name(facewear['Singular'], capitalize: true),
        order: facewear['Order'],
        icons: [],
      }
    end

    %w(de fr ja).each do |locale|
      XIVData.sheet('GlassesStyle', locale: locale).each do |facewear|
        next unless facewear['Name'].present? && facewear['Icon'] != '0'

        id = (facewear['#'].to_i + 1).to_s

        facewears[id]["name_#{locale}"] = sanitize_name(facewear['Name'], locale: locale)
      end
    end

    XIVData.sheet('Glasses').each do |facewear|
      id = (facewear['Style'].to_i + 1).to_s

      next unless facewear['Name'].present?

      facewears[id][:icons] << facewear['Icon']
    end

    count = Facewear.count

    facewears.values.each do |facewear|
      # Skip incomplete facewear
      next if facewear[:icons].empty?

      data = facewear.except(:icons)

      if existing = Facewear.find_by(id: facewear[:id])
        existing.update!(data) if updated?(existing, data)
      else
        Facewear.create!(data)
      end

      # Create the facewear images
      facewear[:icons].each do |icon|
        path = Rails.root.join('public/images/facewear', facewear[:id])
        Dir.mkdir(path) unless Dir.exist?(path)

        output_path = path.join("#{icon}.png")
        create_image(nil, XIVData.image_path(icon), output_path, hd: true)

        # Use the first image as a sample of the facewear
        sample_path = Rails.root.join('public/images/facewear/samples', "#{facewear[:id]}.png")
        FileUtils.cp(output_path, sample_path) unless File.exist?(sample_path)
      end
    end

    create_facewear_spritesheets

    puts "Created #{Facewear.count - count} new facewear"
  end
end
