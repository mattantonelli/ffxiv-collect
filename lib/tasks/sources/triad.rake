namespace :sources do
  namespace :triad do
    desc 'Create card sources from in-game acquisition details'
    task update: :environment do
      achievement_type = SourceType.find_by(name_en: 'Achievement').freeze
      gold_saucer_type = SourceType.find_by(name_en: 'Gold Saucer').freeze

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
        when 11
          source_type = achievement_type
        end

        if source_type.present?
          card = Card.find(card['#'])
          card.sources.find_or_create_by!(text: acquisition, type: source_type)
        end
      end
    end
  end
end
