namespace :quests do
  desc 'Create the quests'
  task create: :environment do
    puts 'Creating quests'

    count = Quest.count
    quests = %w(en de fr ja).each_with_object({}) do |locale, h|
      XIVData.sheet('Quest', locale: locale).each do |quest|
        next unless quest['Name'].present?

        data = h[quest['#']] || { id: quest['#'], reward_id: Item.find_by(name_en: quest['Item{Reward}[0][0]'])&.id&.to_s,
                                  event: quest['FestivalEnd'] != '0' }
        data["name_#{locale}"] = sanitize_text(quest['Name'].gsub(/\uE0BE ?/, ''))
        h[data[:id]] = data
      end
    end

    quests.values.each do |quest|
      if existing = Quest.find_by(id: quest[:id])
        existing.update!(quest) if updated?(existing, quest)
      else
        Quest.find_or_create_by!(quest)
      end
    end

    puts "Created #{Quest.count - count} new quests"
  end
end
