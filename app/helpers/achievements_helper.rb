module AchievementsHelper
  def achievement_icon(achievement)
    image_tag('blank.png', class: 'achievement-icon', style: "background-position: -#{40 * (achievement.id - 1)}px 0")
  end

  def achievement_reward(achievement)
    if achievement.title.present?
      image_tag('title.png', data: { toggle: 'tooltip', title: 'Title Reward' })
    elsif achievement.item_id.present?
      image_tag('item.png', data: { toggle: 'tooltip', title: 'Item Reward' })
    end
  end

  def achievement_item_link(achievement)
    link_to achievement.item_name, "http://www.garlandtools.org/db/#item/#{achievement.item_id}", target: '_blank'
  end
end
