ACHIEVEMENT_COLUMNS = %w(ID Name_* Description_* GamePatch.Version AchievementCategoryTargetID Icon Points Order
Title.IsPrefix Title.Name_*).freeze

namespace :achievements do
  desc 'Create the achievements'
  task create: :environment do
    puts 'Creating achievements'

    XIVAPI_CLIENT.content(name: 'AchievementKind', columns: %w(ID Name_*)).each do |type|
      AchievementType.find_or_create_by!(type.to_h) if type[:name_en].present?
    end

    XIVAPI_CLIENT.content(name: 'AchievementCategory', columns: %w(ID Name_* AchievementKindTargetID)).each do |category|
      category = category.to_h
      category[:type_id] = category.delete(:achievement_kind_target_id)
      AchievementCategory.find_or_create_by!(category) if category[:name_en].present?
    end

    count = Achievement.count
    XIVAPI_CLIENT.content(name: 'Achievement', columns: ACHIEVEMENT_COLUMNS, limit: 10000).each do |achievement|
      next if achievement.achievement_category_target_id == 0

      data = { id: achievement.id, patch: achievement.game_patch.version, points: achievement.points,
               order: achievement.order, category_id: achievement.achievement_category_target_id }

      %w(en de fr ja).each do |locale|
        data["name_#{locale}"] = sanitize_name(achievement["name_#{locale}"])
        data["description_#{locale}"] = sanitize_text(achievement["description_#{locale}"])

        if achievement.title.name_en.present?
          name = achievement.title["name_#{locale}"]
          name = achievement.title.is_prefix == 1 ? "#{name}…" : "…#{name}"
          data["title_#{locale}"] = name
        end
      end

      download_image(achievement.id, achievement.icon, 'achievements')

      if existing = Achievement.find_by(id: achievement.id)
        existing.update!(data) if updated?(existing, data.symbolize_keys)
      else
        Achievement.create!(data)
      end
    end

    create_spritesheet(Achievement, 'achievements', 'achievements.png', 40, 40)

    puts "Created #{Achievement.count - count} new achievements"
  end
end
