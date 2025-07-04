namespace :quests do
  desc 'Create the quests'
  task create: :environment do
    puts 'Creating quests'

    count = Quest.count
    quests = %w(en de fr ja).each_with_object({}) do |locale, h|
      XIVData.sheet('Quest', locale: locale).each do |quest|
        next unless quest['Name'].present?

        # Initialize the data and process rewards on the first pass
        if locale == 'en'
          data = { id: quest['#'], event: quest['FestivalEnd'] != '0' }

          7.times do |i|
            reward = quest["Item{Reward}[#{i}]"]
            break if reward.nil?
            Item.find_by(name_en: reward)&.update!(quest_id: quest['#'])
          end
        else
          data = h[quest['#']]
        end

        data["name_#{locale}"] = sanitize_name(quest['Name'])
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
