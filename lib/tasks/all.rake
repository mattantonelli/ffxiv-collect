require 'open-uri'
require 'sprite_factory'
require 'xiv_data'

namespace :data do
  desc 'Initialize all data'
  task initialize: :environment do
    Rake::Task['triad:card_types:create'].invoke
    Rake::Task['triad:packs:create'].invoke
    Rake::Task['triad:rules:create'].invoke

    Rake::Task['sources:create_types'].invoke
    Rake::Task['data:update'].invoke
    Rake::Task['relics:all:create'].invoke
    Rake::Task['records:sources:create'].invoke
    Rake::Task['survey_records:solutions:set'].invoke
  end

  desc 'Updates all data'
  task update: :environment do
    puts 'Retrieving the latest game data from xiv-data'
    %x{cd #{Rails.root.join('vendor/xiv-data')} && git fetch && git checkout origin/main}

    Rake::Task['items:create'].invoke
    Rake::Task['instances:create'].invoke
    Rake::Task['quests:create'].invoke
    Rake::Task['achievements:create'].invoke
    Rake::Task['titles:create'].invoke
    Rake::Task['mounts:create'].invoke
    Rake::Task['minions:create'].invoke
    Rake::Task['orchestrions:create'].invoke
    Rake::Task['emotes:create'].invoke
    Rake::Task['bardings:create'].invoke
    Rake::Task['hairstyles:create'].invoke
    Rake::Task['armoires:create'].invoke
    Rake::Task['outfits:create'].invoke
    Rake::Task['spells:create'].invoke
    Rake::Task['fashions:create'].invoke
    Rake::Task['facewear:create'].invoke
    Rake::Task['records:create'].invoke
    Rake::Task['survey_records:create'].invoke
    Rake::Task['occult_records:create'].invoke
    Rake::Task['frames:create'].invoke
    Rake::Task['triad:cards:create'].invoke
    Rake::Task['triad:card_images:create'].invoke

    # Sources
    Rake::Task['items:set_unlocks'].invoke
    Rake::Task['items:set_extras'].invoke
    Rake::Task['items:create_images'].invoke
    Rake::Task['sources:update'].invoke

    # Create NPCs after cards are linked to their items
    Rake::Task['triad:npcs:create'].invoke

    # Events
    Rake::Task['tomestones:latest:create'].invoke
    Rake::Task['tomestones:images:create'].invoke
  end
end

def log(message)
  puts "[#{Time.now.strftime('%Y-%m-%d %H:%M:%S %Z')}] #{message}"
end

# Conjunctions/prepositions + Garlean ranks + special characters
WORDS_TO_IGNORE = %w(a an and as at by de for from in into la of on or over the to up with
  aan goe mal oen pyr quo rem sas tol van yae
  α β γ δ).freeze

def sanitize_name(name, locale: 'en', capitalize: false, upcase_first_only: false)
  # Clean up symbols, language tags, etc.
  name = name.gsub('[t]', 'der')
    .gsub('[a]', 'e')
    .gsub('[A]', 'er')
    .gsub('[p]', '')
    .gsub(/[\uE0BE\uE0BF]+ ?/, '') # Remove internal symbols
    .strip # Many achievements, items and quests have trailing spaces

  return name.upcase_first if upcase_first_only

  return name unless capitalize

  # Capitalize for 'en' and 'ja' only ('ja' uses English names sometimes)
  if locale == 'en' || locale == 'ja'
    name = name.split(' ')
      .map { |word| WORDS_TO_IGNORE.include?(word) ? word : word.upcase_first }
      .join(' ')
  end

  name.upcase_first # In case name starts with an ignored word
end

def sanitize_text(text, preserve_space: false)
  return '' if text.nil?

  unless preserve_space
    text = text.gsub("-\n", '-')
      .gsub("\n", ' ')
  end

  text.gsub(/[\uE0BE\uE0BF]+ ?/, '').strip
end

def without_custom(data)
  data.symbolize_keys.except(:name_en, :name_fr, :name_de, :name_ja, :patch)
end

def updated?(model, data)
  data.symbolize_keys!
  current = model.attributes.symbolize_keys.select { |k, _| data.keys.include?(k) }

  # Add associated IDs which are not part of the model's attributes. Sort them for proper comparison.
  data.each do |k, v|
    if v.is_a?(Array)
      current[k] = model.send(k).sort
      v.sort!
    end
  end

  # The XIVData values are all strings, so convert integers to strings for comparison
  current.each do |k, v|
    current[k] = v.to_s if v.is_a?(Integer)
  end

  if updated = data != current
    puts "  Found new data for #{model.name_en} (#{model.id}):"
    diff = data.map do |k, v|
      "#{k}: #{current[k]} → #{v}" if current[k] != v
    end
    puts "    #{diff.compact.join(', ')}"
  end

  updated
end

def maps_with_locations(ids)
  # Look up the maps for the given IDs and set the coordinate data
  maps = XIVData.sheet('Map').each_with_object({}) do |map, h|
    if ids.include?(map['#'])
      h[map['#']] = { region_id: map['PlaceNameRegion'], location_id: map['PlaceName'],
                      x_offset: map['OffsetX'].to_f, y_offset: map['OffsetY'].to_f,
                      size_factor: map['SizeFactor'].to_f }
    end
  end

  # Look up the locations associated with each map
  locations = %w(en fr de ja).each_with_object(Hash.new({})) do |locale, h|
    places = XIVData.sheet('PlaceName', locale: locale).map { |place| place['Name']}
    maps.values.each do |map|
      h[map[:location_id]] = h[map[:location_id]].merge("name_#{locale}" => places[map[:location_id].to_i],
                                                        "region_#{locale}" => places[map[:region_id].to_i])
    end
  end

  # Create the locations
  locations.each do |id, data|
    Location.find_or_create_by!(data.merge(id: id))
  end

  maps
end

def get_coordinate(value, map_offset, size_factor)
  scale = size_factor / 100.0
  offset = (value + map_offset) * scale
  (((40.9 / scale) * ((offset + 1024.0) / 2048.0)) + 1).round(1)
end

def create_image(id, image_path, path, hd: false, mask_from: nil, mask_to: nil, width: nil, height: nil)
  # Use the custom output pathname if provided, otherwise generate it
  if path.class == Pathname
    output_path = path
  else
    output_path = Rails.root.join('public/images', path, "#{id}.png")
  end

  # Do not re-download existing images. These can be deleted manually if new versions are needed.
  return if output_path.exist?

  asset = XIVData.download_image(image_path, hd: hd).body

  if mask_from.present?
    mask_to ||= mask_from
    image = ChunkyPNG::Image.from_blob(asset)
    image.change_theme_color!(
      ChunkyPNG::Color.from_hex(mask_from),
      ChunkyPNG::Color.from_hex(mask_to),
      ChunkyPNG::Color::TRANSPARENT
    )
  elsif width.present?
    image = ChunkyPNG::Image.from_blob(asset)
    image.resample_bilinear!(width, height)
  else
    image = asset
  end

  URI.open(output_path, 'wb') { |file| file << image }
end

def create_spritesheet(path)
  output_image = path.gsub('/', '-')
  class_name = output_image.singularize
  options = { style: :scss, layout: :packed, library: :chunkypng,
              nocomments: true, output_image: Rails.root.join('app/assets/images', "#{output_image}.png"),
              output_style: Rails.root.join('app/assets/stylesheets/images', "#{output_image}.scss") }

  SpriteFactory.run!(Rails.root.join('public/images', path), options) do |images|
    rules = []
    image = images.values.first

    rules << "img.#{class_name} { width: #{image[:width]}px; height: #{image[:height]}px; " \
      "background: url(image_path('#{output_image}.png')) no-repeat }"

    images.each do |_, img|
      rules << "img.#{class_name}-#{img[:name]} { background-position: #{-img[:cssx]}px #{-img[:cssy]}px }"
    end

    rules.join("\n")
  end
end

def create_hair_spritesheets
  Hairstyle.all.each do |hairstyle|
    images = Dir.glob(Rails.root.join('public/images/hairstyles', hairstyle.id.to_s, '*.png'))
      .sort_by { |filename| filename[/(\d+).png/].to_i }
    sheet = ChunkyPNG::Image.new(192 * images.size, 192)

    images.each_with_index do |image, i|
      sheet.compose!(ChunkyPNG::Image.from_file(image), 192 * i, 0)
    end

    sheet.save(Rails.root.join('app/assets/images/hairstyles', "#{hairstyle.id}.png").to_s)
  end
end

def create_facewear_spritesheets
  Facewear.all.each do |facewear|
    images = Dir.glob(Rails.root.join('public/images/facewear', facewear.id.to_s, '*.png')).sort
    sheet = ChunkyPNG::Image.new(80 * images.size, 80)

    images.each_with_index do |image, i|
      sheet.compose!(ChunkyPNG::Image.from_file(image), 80 * i, 0)
    end

    sheet.save(Rails.root.join('app/assets/images/facewear', "#{facewear.id}.png").to_s)
  end
end
