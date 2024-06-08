namespace 'sources' do
  namespace 'related' do
    desc 'Translate sources with related IDs'
    task translate: :environment do
      PaperTrail.enabled = false
      Source.skip_callback(:save, :before, :assign_relations!)

      puts 'Translating automated sources'

      # Related sources (e.g. achievements)
      Source.where.not(related_type: nil).where.not(related_id: nil).includes(:related).each do |source|
        %w(de fr ja).each do |locale|
          source["text_#{locale}"] = source.related["name_#{locale}"]
        end

        source.save!
      end

      # Crafting sources
      crafting_type = SourceType.find_by(name_en: 'Crafting')
      Item.where.not(unlock_type: nil).where.not(recipe_id: nil).each do |item|
        source = Source.find_by(collectable_id: item.unlock_id, collectable_type: item.unlock_type,
                                type: crafting_type)

        texts = %w(en de fr).each_with_object({}) do |locale, h|
          job = I18n.t("leves.categories.#{item.crafter.downcase}", locale: locale)
          h["text_#{locale}"] = I18n.t("sources.crafted", job: job, locale: locale)
        end

        source.update!(**texts)
      end
    end
  end

  namespace 'csv' do
    desc 'Update source translations based on CSV data'
    task translate: :environment do
      PaperTrail.enabled = false
      Source.skip_callback(:save, :before, :assign_relations!)

      puts 'Updating source translations with CSV data'

      file = Rails.root.join('vendor/sources/translations.csv')

      CSV.foreach(file) do |row|
        sources = Source.where(text_en: row[0])

        if sources.size == 0
          puts "Could not find matching source for text: #{row[0]}"
        else
          sources.update_all(text_fr: row[1], text_de: row[2])
        end
      end
    end
  end
end
