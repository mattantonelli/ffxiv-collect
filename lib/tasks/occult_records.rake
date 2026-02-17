namespace :occult_records do
  desc 'Create the occult records'
  task create: :environment do
    PaperTrail.enabled = false

    puts 'Creating occult records'

    count = OccultRecord.count

    records = %w(en de fr ja).each_with_object({}) do |locale, h|
      XIVData.sheet('MKDLore', locale: locale).each do |record|
        next unless record['Name'].present?

        data = h[record['#']] || { id: record['#'], image: record['Image'] }

        data["name_#{locale}"] = sanitize_name(record['Name'], locale: locale)
        data["description_#{locale}"] = sanitize_text(record['Description'], preserve_space: true)
        h[data[:id]] = data
      end
    end

    records.values.each do |record|
      create_image(record[:id], XIVData.image_path(record.delete(:image)), 'occult_records')

      if existing = OccultRecord.find_by(id: record[:id])
        existing.update!(record) if updated?(existing, record)
      else
        OccultRecord.create!(record)
      end
    end

    puts "Created #{OccultRecord.count - count} new occult records"
  end
end
