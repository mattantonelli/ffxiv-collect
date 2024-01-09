namespace :triad do
  namespace :sources do
    desc 'Create card sources from in-game Acquisition details and shops'
    task update: :environment do
      gold_saucer_type = SourceType.find_by(name_en: 'Gold Saucer').freeze
      purchase_type = SourceType.find_by(name_en: 'Purchase').freeze

      puts 'Creating card Acqusition sources'
      XIVData.sheet('TripleTriadCardResident').each do |card|
        type = card['AcquisitionType'].to_i
        acquisition = card['Acquisition']

        case type
        when 2, 3
          if instance = Instance.find_by(name_en: acquisition)
            acquisition = instance.name_en
            source_type = SourceType.find_by(name_en: instance.content_type)
          end
        # when 4, 5
        #   origin = 'FATE'
        #   acquisition = "FATE: #{acquisition}"
        when 8, 9
          next unless acquisition =~ /Triad Card/
          source_type = gold_saucer_type
          pack = Pack.find_by(name_en: acquisition)
          PackCard.find_or_create_by!(pack_id: pack.id, card_id: card['#'])
        end

        if source_type.present?
          card = Card.find(card['#'])
          card.sources.find_or_create_by!(text: acquisition, type: source_type)
        end
      end

      puts 'Creating card SpecialShop sources'
      XIVData.sheet('SpecialShop', locale: 'en').each do |shop|
        60.times do |i|
          item = shop["Item{Receive}[#{i}][0]"]
          break if item.nil?
          next unless item.match?(/ Card$/) &&
            card = Card.where('BINARY name_en like ?', "%#{item.sub(/ Card$/, '')}%").first

          price = shop["Count{Cost}[#{i}][0]"]
          next if price == '0'

          currency = shop["Item{Cost}[#{i}][0]"]

          if currency == 'MGP'
            card.update!(buy_price: price) unless card.buy_price.present?
          elsif card.sources.none?
            card.sources.create!(text: "#{price} #{currency.pluralize}", type: purchase_type)
          end
        end
      end
    end
  end
end
