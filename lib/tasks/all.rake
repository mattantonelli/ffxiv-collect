namespace :data do
  desc 'Initialize all data'
  task initialize: :environment do
    puts 'Loading all data'
    Rake::Task['mounts:create'].invoke
  end

  desc 'Updates all data'
  task update: :environment do
    puts 'Updating all data'
    Rake::Task['mounts:create'].invoke
  end
end

# Replace various tags with the appropriate text
def sanitize_text(text)
  text.gsub('<SoftHyphen/>', "\u00AD")
    .gsub(/<Switch.*?><Case\(1\)>(.*?)<\/Case>.*?<\/Switch>/, '\1')
    .gsub(/<If.*?>(.*?)<Else\/>.*?<\/If>/, '\1')
    .gsub(/<\/?Emphasis>/, '*')
    .gsub('<Indent/>', ' ')
    .gsub(/\<.*?\>/, '')
    .gsub("\r", "\n")
end

# Fix lowercase names and German gender tags
def sanitize_name(name)
  name = name.titleize if name =~ /^[a-z]/
  name.gsub('[t]', 'der')
    .gsub('[a]', 'e')
    .gsub('[A]', 'er')
    .gsub('[p]', '')
end

def updated?(model, data)
  current = model.attributes.symbolize_keys.select { |k, _| data.keys.include?(k) }

  if updated = data != current
    puts "  Found new data for #{model.id}:"
    diff = data.map do |k, v|
      "#{k}: #{current[k]} → #{v}" if current[k] != v
    end
    puts "    #{diff.compact.join(', ')}"
  end

  updated
end

def download_image(id, url, path, mask_from = nil, mask_to = nil)
  path = Rails.root.join('public/images', path, "#{id}.png")

  unless path.exist?
    image_url = "https://xivapi.com#{url}"

    begin
      if mask_from.present?
        mask_to ||= mask_from
        image = ChunkyPNG::Image.from_stream(open(image_url))
        image.change_theme_color!(ChunkyPNG::Color.from_hex(mask_from), ChunkyPNG::Color.from_hex(mask_to),
                                  ChunkyPNG::Color::TRANSPARENT)
      else
        image = open(image_url).read
      end
      open(path.to_s, 'wb') { |file| file << image }
    rescue Exception
      puts "Could not download image: #{image_url}"
    end
  end
end

def create_spritesheet(model, source, destination, width, height)
  ids = model.order(:id).pluck(:id)
  sheet = ChunkyPNG::Image.new(width * model.pluck(:id).max, height)

  ids.each do |id|
    image = Rails.root.join('public/images', source, "#{id}.png")
    if image.exist?
      sheet.compose!(ChunkyPNG::Image.from_file(image), width * (id - 1), 0)
    else
      puts "Could not locate image: #{image}"
    end
  end

  sheet.save(Rails.root.join('app/assets/images', destination).to_s)
end
