module AchievementsHelper
  def achievement_reward(achievement)
    if achievement.title.present?
      image_tag('title.png', data: { toggle: 'tooltip', title: title_name(achievement.title), html: true })
    elsif achievement.item_id.present?
      image_tag('item.png', data: { toggle: 'tooltip', title: achievement.item.name })
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

  def achievement_completion(achievements, ids)
    complete = (achievements.map(&:id) & ids).size
    points = achievements.select { |achievement| ids.include?(achievement.id) }.map(&:points).sum
    total_points = achievements.pluck(:points).sum

    "#{complete} #{t('of')} #{achievements.size} #{t('complete')}. #{points}/#{total_points} #{fa_icon('star')}".html_safe
  end

  def completed?(achievements, ids)
    (achievements.map(&:id) - ids).size == 0
  end

  def achievement_count(achievements, ids)
    (achievements.map(&:id) & ids).size
  end

  def point_count(achievements, ids)
    achievements.select { |achievement| ids.include?(achievement.id) }.map(&:points).sum
  end
end
