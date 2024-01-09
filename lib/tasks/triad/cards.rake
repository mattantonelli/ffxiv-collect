require 'xiv_data'

namespace :triad do
  namespace :cards do
    desc 'Create the cards'
    task create: :environment do
      puts 'Creating cards'
      count = Card.count

      # Load the base cards
      cards = XIVData.sheet('TripleTriadCard', locale: 'en').each_with_object({}) do |card, h|
        h[card['#']] = { id: card['#'], name_en: sanitize_card_name(card['Name']),
                         description_en: sanitize_text(card['Description']) }
      end

      %w(fr de ja).each do |locale|
        XIVData.sheet('TripleTriadCard', locale: locale).each do |card|
          cards[card['#']].merge!("name_#{locale}" => sanitize_card_name(card['Name']),
                                  "description_#{locale}" => sanitize_text(card['Description']))
        end
      end

      # Add their various stats
      XIVData.sheet('TripleTriadCardResident').each do |card|
        stars = card['TripleTriadCardRarity'].scan(/\d$/).first
        type_id = CardType.find_by(name_en: card['TripleTriadCardType'])&.id || '0'
        formatted_number = card['UIPriority'] == '0' ? "No. #{card['Order']}" : "Ex. #{card['Order']}"

        cards[card['#']].merge!(top: card['Top'], bottom: card['Bottom'],
                                left: card['Left'], right: card['Right'],
                                stars: stars, card_type_id: type_id.to_s, sell_price: card['SaleValue'],
                                deck_order: card['SortKey'], order_group: card['UIPriority'],
                                order: card['Order'], formatted_number: formatted_number)
      end

      # Then create or update them
      cards.each do |id, data|
        if card = Card.find_by(id: data[:id])
          card.update!(data) if updated?(card, data)
        else
          card = Card.create!(data) if data[:name_en].present?
        end
      end

      puts "Created #{Card.count - count} new cards"
    end

    def sanitize_card_name(name)
      name = name.titleize if name =~ /^[a-z]/

      name.gsub('[t]', 'der')
        .gsub('[a]', 'e')
        .gsub('[A]', 'er')
        .gsub('[p]', '')
    end
  end
end
