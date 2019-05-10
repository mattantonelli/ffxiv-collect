module AchievementsHelper
  def achievement_icon(achievement)
    image_tag('blank.png', class: 'achievement-icon', style: "background-position: -#{40 * (achievement.id - 1)}px 0")
  end

  def achievement_reward(achievement)
    if achievement.title.present?
      image_tag('title.png', data: { toggle: 'tooltip', title: achievement.title })
    elsif achievement.item_id.present?
      image_tag('item.png', data: { toggle: 'tooltip', title: achievement.item_name })
    end
  end

  def achievement_item_link(achievement)
    link_to achievement.item_name, "http://www.garlandtools.org/db/#item/#{achievement.item_id}", target: '_blank'
  end

  def achievement_completion(category, ids)
    achievements = category.achievements
    complete = (achievements.map(&:id) & ids).size
    points = achievements.select { |achievement| ids.include?(achievement.id) }.pluck(:points).sum
    total_points = achievements.pluck(:points).sum

    "#{complete} of #{achievements.size} complete. #{points}/#{total_points} #{fa_icon('star')}".html_safe
  end

  def completed?(category, ids)
    (category.achievements.map(&:id) - ids).size == 0
  end
end
