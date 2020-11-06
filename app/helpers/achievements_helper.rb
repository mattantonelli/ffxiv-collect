module AchievementsHelper
  def achievement_reward(achievement)
    if achievement.title.present?
      image_tag('title.png', data: { toggle: 'tooltip', title: title_name(achievement.title), html: true })
    elsif achievement.item_id.present?
      image_tag('item.png', data: { toggle: 'tooltip', title: achievement.item_name })
    end
  end

  def achievement_reward_value(achievement)
    if achievement.title.present?
      2
    elsif achievement.item_id.present?
      1
    else
      0
    end
  end

  def link_to_achievement_item(achievement)
    database_link(:item, achievement.item_name, achievement.item_id)
  end

  def achievement_completion(category, ids)
    achievements = category.achievements
    complete = (achievements.map(&:id) & ids).size
    points = achievements.select { |achievement| ids.include?(achievement.id) }.pluck(:points).sum
    total_points = achievements.pluck(:points).sum

    "#{complete} #{t('general.of')} #{achievements.size} #{t('general.complete')}. #{points}/#{total_points} #{fa_icon('star')}".html_safe
  end

  def completed?(category, ids)
    (category.achievements.map(&:id) - ids).size == 0
  end

  def type_count(achievement_ids, type)
    (type.achievements.pluck(:id) & achievement_ids).size
  end

  def type_points(achievement_ids, type)
    Achievement.where(id: type.achievements.pluck(:id) & achievement_ids).pluck(:points).sum
  end
end
