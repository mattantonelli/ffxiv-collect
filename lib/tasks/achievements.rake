ACHIEVEMENT_COLUMNS = %w(ID Name_* Description_* GamePatch.Version AchievementCategoryTargetID Icon IconID Points Order
Title.* Item.ID Item.Icon Item.Name_*).freeze

namespace :achievements do
  desc 'Create the achievements'
  task create: :environment do
    PaperTrail.enabled = false

    puts 'Creating achievement types'
    XIVAPI_CLIENT.content(name: 'AchievementKind', columns: %w(ID Name_* Order)).each do |type|
      if type[:name_en].present? && type[:name_en] != 'Gathering'
        data = type.to_h.slice(:id, :name_en, :name_de, :name_fr, :name_ja, :order)

        if existing = AchievementType.find_by(id: data[:id])
          existing.update!(data) if updated?(existing, data.symbolize_keys)
        else
          AchievementType.find_or_create_by!(data)
        end
      end
    end

    puts 'Creating achievement categories'
    XIVAPI_CLIENT.content(name: 'AchievementCategory', columns: %w(ID Name_* AchievementKindTargetID Order)).each do |category|
      category = category.to_h.slice(:id, :name_en, :name_de, :name_fr, :name_ja, :achievement_kind_target_id, :order)
      category[:type_id] = category.delete(:achievement_kind_target_id)
      next unless category[:name_en].present?

      if existing = AchievementCategory.find_by(id: category[:id])
        existing.update!(category) if updated?(existing, category.symbolize_keys)
      else
        AchievementCategory.find_or_create_by!(category)
      end
    end

    puts 'Creating achievements'
    count = Achievement.count
    XIVAPI_CLIENT.content(name: 'Achievement', columns: ACHIEVEMENT_COLUMNS, limit: 10000).each do |achievement|
      next if achievement.achievement_category_target_id == 0

      data = { id: achievement.id, patch: achievement.game_patch.version, points: achievement.points,
               order: achievement.order, category_id: achievement.achievement_category_target_id, icon_id: achievement.icon_id }

      %w(en de fr ja).each do |locale|
        data["name_#{locale}"] = sanitize_name(achievement["name_#{locale}"])
        data["description_#{locale}"] = sanitize_text(achievement["description_#{locale}"])

        if achievement.item.id.present?
          data[:item_id] = achievement.item.id
          data["item_name_#{locale}"] = achievement.item["name_#{locale}"]
          download_image(achievement.item.id, achievement.item.icon,
                         Rails.root.join('app/assets/images/items', "#{achievement.item.id}.png"))
        end
      end

      download_image(achievement.icon_id, achievement.icon, 'achievements')

      if existing = Achievement.find_by(id: achievement.id)
        data = data.symbolize_keys.except(:patch)
        existing.update!(data) if updated?(existing, data.symbolize_keys)
      else
        Achievement.create!(data)
      end
    end

    create_spritesheet('achievements')

    puts "Created #{Achievement.count - count} new achievements"
  end
end
