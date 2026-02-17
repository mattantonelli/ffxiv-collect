namespace :survey_records do
  desc 'Create the survey records'
  task create: :environment do
    PaperTrail.enabled = false

    puts 'Creating survey records'

    SurveyRecordSeries.find_or_create_by!(id: 1, name_en: "The Sil'dihn Subterrane", name_de: "Unterstadt Von Sil'dih",
                                          name_fr: "Canalisations Sildiennes", name_ja: "シラディハ水道")
    SurveyRecordSeries.find_or_create_by!(id: 2, name_en: 'Mount Rokkon', name_de: 'Der Rokkon',
                                          name_fr: 'Le mont Rokkon', name_ja: '六根山')
    SurveyRecordSeries.find_or_create_by!(id: 3, name_en: 'Aloalo Island', name_de: 'Aloalo',
                                          name_fr: "L'île d'Aloalo", name_ja: 'アロアロ島')

    series_record_ids = XIVData.sheet('VVDNotebookSeries').each_with_object({}) do |series, h|
      next unless series['Name'].present?

      h[series['#']] = series.filter_map do |k, v|
        v if k =~ /Contents/
      end
    end

    count = SurveyRecord.count

    records = %w(en de fr ja).each_with_object({}) do |locale, h|
      XIVData.sheet('VVDNotebookContents', locale: locale).each do |record|
        next unless record['Name'].present?

        data = h[record['#']] || { id: record['#'], icon: record['Icon'], image: record['Image'] }
        data["name_#{locale}"] = sanitize_name(record['Name'], locale: locale)
        data["description_#{locale}"] = sanitize_text(record['Description'].gsub(/(?<!\n)\n(?!\n)/, "\n\n"),
                                                      preserve_space: true)
        h[data[:id]] = data
      end
    end

    # Assign the series ID and order to each record
    series_record_ids.each do |series_id, record_ids|
      record_ids.each.with_index(1) do |record_id, order|
        records[record_id][:series_id] = series_id
        records[record_id][:order] = order.to_s
      end
    end

    records.values.each do |record|
      create_image(record[:id], XIVData.image_path(record.delete(:image)), 'survey_records/large')
      create_image(record[:id], XIVData.image_path(record.delete(:icon)), 'survey_records/small')

      if existing = SurveyRecord.find_by(id: record[:id])
        existing.update!(record) if updated?(existing, record)
      else
        SurveyRecord.create!(record)
      end
    end

    create_spritesheet('survey_records/small')

    puts "Created #{SurveyRecord.count - count} new Survey Records"
  end

  namespace :solutions do
    desc 'Set survey record solutions'
    task set: :environment do
      PaperTrail.enabled = false
      puts 'Setting survey record solutions'
      file = Rails.root.join('vendor/sources/survey_records.csv')

      CSV.foreach(file) do |row|
        id, solution = row
        SurveyRecord.find_by(id: id).update!(solution_en: solution)
      end
    end
  end
end
