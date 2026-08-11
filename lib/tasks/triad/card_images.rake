require 'xiv_data'

namespace :triad do
  namespace :card_images do
    LARGE_CARDS_DIR = Rails.root.join('public/images/cards/large').freeze
    CARD_IMAGES_DIR = Rails.root.join('app/assets/images/cards').freeze

    BACKGROUND = ChunkyPNG::Image.from_file(CARD_IMAGES_DIR.join('background.png')).freeze
    STAR = ChunkyPNG::Image.from_file(CARD_IMAGES_DIR.join('star.png')).freeze
    LARGE_OFFSET = 87000.freeze

    # Index corresponds with type ID
    TYPES = %w(primal scion society garlean).map do |type|
      ChunkyPNG::Image.from_file(CARD_IMAGES_DIR.join("#{type}.png"))
    end

    number_sheet = ChunkyPNG::Image.from_file(CARD_IMAGES_DIR.join('numbers.png'))
    NUMBERS = 10.times.map { |i| number_sheet.crop(30 * i, 0, 30, 30) }.freeze

    desc 'Create the images for each card'
    task create: :environment do
      next if ENV['SKIP_IMAGES']

      puts 'Creating card images'

      count = Dir.entries(LARGE_CARDS_DIR).size

      Card.all.each do |card|
        path = LARGE_CARDS_DIR.join("#{card.id}.png")

        unless path.exist?
          save_card_image(card, path)
        end
      end

      puts "Created #{Dir.entries(LARGE_CARDS_DIR).size - count} card images"
    end
  end

  def save_card_image(card, path)
    blob = XIVData.download_image(XIVData.image_path(LARGE_OFFSET + card.id, hd: true)).body
    image = BACKGROUND.compose(ChunkyPNG::Image.from_blob(blob))

    if card.card_type_id > 0
      image.compose!(TYPES[card.card_type_id - 1], 160, 6)
    end

    card.stars.times do |stars|
      case(stars + 1)
      when 1 then image.compose!(STAR, 34, 9)
      when 2 then image.compose!(STAR, 16, 21)
      when 3 then image.compose!(STAR, 50, 21)
      when 4 then image.compose!(STAR, 24, 39)
      when 5 then image.compose!(STAR, 44, 39)
      end
    end

    image.compose!(NUMBERS[card.top - 1], 90, 182)
    image.compose!(NUMBERS[card.right - 1], 116, 194)
    image.compose!(NUMBERS[card.bottom - 1], 90, 206)
    image.compose!(NUMBERS[card.left - 1], 64, 194)

    image.save(path)
  end
end
