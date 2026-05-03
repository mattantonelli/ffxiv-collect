namespace 'sources' do
  namespace 'csv' do
    desc 'Update voyage sources based on CSV data'
    task voyages: :environment do
      PaperTrail.enabled = false
      Source.skip_callback(:save, :before, :assign_relations!)

      puts 'Updating voyage sources with CSV data'

      file = Rails.root.join('vendor/sources/voyages_update.csv')

      CSV.foreach(file) do |row|
        sources = Source.where(text_en: row[0])

        if sources.size == 0
          puts "Could not find matching source for text: #{row[0]}"
        else
          sources.update_all(text_en: row[1], text_fr: nil, text_de: nil, text_ja: nil, text_tc: nil)
        end
      end
    end
  end
end
