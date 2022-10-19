namespace :survey_records do
  desc 'Create the survey records'
  task create: :environment do
    PaperTrail.enabled = false

    puts 'Creating survey records'

    SurveyRecordSeries.find_or_create_by!(id: 1, name_en: "The Sil'dihn Subterrane", name_de: "Unterstadt Von Sil'dih",
                                          name_fr: "Canalisations Sildiennes", name_ja: "シラディハ水道")

    series_records = XIVData.sheet('VVDNotebookSeries', raw: true).each_with_object({}) do |series, h|
      h[series['#']] = record_ids = series.filter_map do |k, v|
        v if k =~ /Contents/
      end
    end

    count = SurveyRecord.count

    records = %w(en de fr ja).each_with_object({}) do |locale, h|
      XIVData.sheet('VVDNotebookContents', locale: locale).each do |record|
        next unless record['Name'].present?

        data = h[record['#']] || { id: record['#'], icon: record['Icon'], image: record['Image'] }
        data["name_#{locale}"] = sanitize_name(record['Name'])
        data["description_#{locale}"] = sanitize_text(record['Description'].gsub("\n", "\n\n"), preserve_space: true)
        h[data[:id]] = data
      end
    end

    records.values.each do |record|
      series_records.each do |series_id, record_ids|
        if record_ids.include?(record[:id])
          break record[:series_id] = series_id
        end
      end

      create_image(record[:id], record.delete(:image), 'survey_records/large')
      create_image(record[:id], record.delete(:icon), 'survey_records/small')

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
        SurveyRecord.find_by(id: id).update!(solution: solution)
      end
    end
  end
end
