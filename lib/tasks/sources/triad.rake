namespace :sources do
  namespace :triad do
    desc 'Create card sources from in-game acquisition details'
    task update: :environment do
      PaperTrail.enabled = false

      achievement_type = SourceType.find_by(name_en: 'Achievement').freeze
      gold_saucer_type = SourceType.find_by(name_en: 'Gold Saucer').freeze

      puts 'Creating Card acqusition sources'
      XIVData.sheet('TripleTriadCardResident').each do |card|
        type = card['AcquisitionType'].to_i
        acquisition = card['Acquisition']
        texts = { "text_en" => acquisition }

        case type
        when 2, 3
          if instance = Instance.find_by(name_en: acquisition)
            source_type = SourceType.find_by(name_en: instance.content_type)
            %w(en de fr ja).each_with_object({}) do |locale, h|
              texts["text_#{locale}"] = instance["name_#{locale}"]
            end
          end
        # when 4, 5
        #   origin = 'FATE'
        #   acquisition = "FATE: #{acquisition}"
        when 8, 9
          next unless acquisition =~ /Triad Card/
          source_type = gold_saucer_type
          pack = Pack.find_by(name_en: acquisition)
          PackCard.find_or_create_by!(pack_id: pack.id, card_id: card['#'])

          %w(en de fr ja).each_with_object({}) do |locale, h|
            texts["text_#{locale}"] = pack["name_#{locale}"]
          end
        when 11
          source_type = achievement_type
          achievement = Achievement.find_by(name_en: acquisition)

          %w(en de fr ja).each_with_object({}) do |locale, h|
            texts["text_#{locale}"] = achievement["name_#{locale}"]
          end
        end

        if source_type.present?
          card = Card.find(card['#'])

          next if card.sources.any?

          card.sources.create!(**texts, type: source_type)
        end
      end
    end
  end
end
