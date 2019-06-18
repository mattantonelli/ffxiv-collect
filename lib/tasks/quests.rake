namespace :quests do
  desc 'Create the quests'
  task create: :environment do
    puts 'Creating quests'

    count = Quest.count
    XIVAPI_CLIENT.search(indexes: 'Quest', columns: %w(ID Name_*), limit: 10000).each do |quest|
      next unless quest.name_en.present?

      data = { id: quest.id }

      %w(en de fr ja).each do |locale|
        data["name_#{locale}"] = sanitize_name(quest["name_#{locale}"])
      end

      if existing = Quest.find_by(id: quest.id)
        existing.update!(data) if updated?(existing, data.symbolize_keys)
      else
        Quest.create!(data)
      end
    end

    puts "Created #{Quest.count - count} new quests"
  end
end
