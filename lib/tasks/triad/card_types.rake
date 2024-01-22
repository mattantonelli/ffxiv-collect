require 'xiv_data'

namespace :triad do
  namespace :card_types do
    desc 'Create the card types'
    task create: :environment do
      PaperTrail.enabled = false

      puts 'Creating card types'
      count = CardType.count

      # Typeless cards reference ID 0, so create it
      CardType.find_or_create_by!(id: 0, name_en: 'Normal', name_de: 'Normal', name_fr: 'Normal', name_ja: 'ノーマル')

      types = %w(en de fr ja).map do |locale|
        XIVData.sheet('TripleTriadCardType', locale: locale).map do |type|
          type['Name'] unless type['Name'].blank?
        end
      end

      types.transpose.each_with_index do |type, i|
        CardType.find_or_create_by!(id: i + 1, name_en: type[0], name_de: type[1], name_fr: type[2], name_ja: type[3])
      end

      puts "Created #{CardType.count - count} new card types"
    end
  end
end
