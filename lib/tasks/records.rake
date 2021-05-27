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

        data["name_#{locale}"] = sanitize_name(record['Name'])
        data["description_#{locale}"] = sanitize_skill_description(record['Description'])
        h[data[:id]] = data
      end
    end

    links.values.each do |link|
      records[link[0]][:linked_record_id] = link[1]
      records[link[1]][:linked_record_id] = link[0]
    end

    records.values.each do |record|
      create_image(record[:id], record.delete(:image), 'records/large')
      create_image(record[:id], record.delete(:icon), 'records/small')

      if existing = Record.find_by(id: record[:id])
        existing.update!(record) if updated?(existing, record)
      else
        Record.create!(record)
      end
    end

    Record.where(id: 1..20).update_all(patch: '5.35')
    Record.where(id: 21..30).update_all(patch: '5.45')
    Record.where(id: 31..50).update_all(patch: '5.55')

    create_spritesheet('records/small')

    puts "Created #{Record.count - count} new field records"
  end

  namespace :sources do
    desc 'Create the field record sources'
    task create: :environment do
      PaperTrail.enabled = false
      puts 'Creating field records'
      file = Rails.root.join('vendor/sources/records.csv')

      bozja = SourceType.find_by(name: 'Bozja')
      quest = SourceType.find_by(name: 'Quest')

      CSV.foreach(file) do |row|
        id, source = row

        if source.match?('Quest')
          source = source.gsub('Quest: ', '')
          source_type = quest
        else
          source_type = bozja
        end

        Record.find_by(id: id).sources.find_or_create_by!(type: source_type, text: source)
      end
    end
  end
end
