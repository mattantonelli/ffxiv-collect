TITLE_COLUMNS = %w(ID Name_* NameFemale_* IsPrefix Order GameContentLinks)

namespace :titles do
  desc 'Create the titles'
  task create: :environment do
    puts 'Creating titles'
    count = Title.count

    XIVAPI_CLIENT.content(name: 'Title', columns: TITLE_COLUMNS, limit: 10000).each do |title|
      next if title.order == 0
      data = { id: title.id, order: title.order, achievement_id: title.game_content_links.achievement.title.first }

      %w(en de fr ja).each do |locale|
        if title.is_prefix == 1
          data["name_#{locale}"] = "#{title["name_#{locale}"]}…"
          data["female_name_#{locale}"] = "#{title["name_female_#{locale}"]}…"
        else
          data["name_#{locale}"] = "…#{title["name_#{locale}"]}"
            data["female_name_#{locale}"] = "…#{title["name_female_#{locale}"]}"
        end
      end

      if existing = Title.find_by(id: title.id)
        existing.update!(data) if updated?(existing, data.symbolize_keys)
      else
        Title.create!(data)
      end
    end

    puts "Created #{Title.count - count} new titles"
  end
end
