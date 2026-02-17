namespace :records do
  desc 'Create the field records'
  task create: :environment do
    PaperTrail.enabled = false

    puts 'Creating field records'

    count = Record.count
    links = Hash.new { [] }

    records = %w(en de fr ja).each_with_object({}) do |locale, h|
      XIVData.sheet('MYCWarResultNotebook', locale: locale).each do |record|
        next unless record['Name'].present?

        # Set record links on the first pass
        unless h.has_key?(record['Number']) || record['Link'] == '0'
          links[record['Link']] <<= record['Number']
        end

        data = h[record['Number']] || { id: record['Number'], rarity: record['Rarity'],
                                        icon: record['Icon'], image: record['Image'] }

        data["name_#{locale}"] = sanitize_name(record['Name'], locale: locale)
        data["description_#{locale}"] = sanitize_text(record['Description'], preserve_space: true)
        h[data[:id]] = data
      end
    end

    links.values.each do |link|
      records[link[0]][:linked_record_id] = link[1]
      records[link[1]][:linked_record_id] = link[0]
    end

    records.values.each do |record|
      # Append I/II suffixes to records with multiple entries
      if record[:linked_record_id].present? && !record['name_en'].match?(/^Lyon /)
        suffix = record[:linked_record_id].to_i > record[:id].to_i ? 'I' : 'II'
        %w(name_en name_de name_fr name_ja).each do |name|
          record[name] = "#{record[name]} #{suffix}"
        end
      end

      create_image(record[:id], XIVData.image_path(record.delete(:image)), 'records/large')
      create_image(record[:id], XIVData.image_path(record.delete(:icon)), 'records/small')

      if existing = Record.find_by(id: record[:id])
        existing.update!(record) if updated?(existing, record)
      else
        Record.create!(record)
      end
    end

    Record.where(id: 1..20).update_all(location: 'Southern Front', patch: '5.35')
    Record.where(id: 21..30).update_all(location: 'Delubrium Reginae', patch: '5.45')
    Record.where(id: 31..50).update_all(location: 'Zadnor', patch: '5.55')

    create_spritesheet('records/small')

    puts "Created #{Record.count - count} new field records"
  end

  namespace :sources do
    desc 'Create the field record sources'
    task create: :environment do
      PaperTrail.enabled = false
      puts 'Creating field record sources'
      file = Rails.root.join('vendor/sources/records.csv')

      bozja = SourceType.find_by(name_en: 'Bozja')
      quest = SourceType.find_by(name_en: 'Quest')

      CSV.foreach(file) do |row|
        id, source = row

        if source.match?('Quest')
          source = source.gsub('Quest: ', '')
          source_type = quest
        else
          source_type = bozja
        end

        Record.find_by(id: id).sources.find_or_create_by!(type: source_type, text_en: source)
      end
    end
  end
end
