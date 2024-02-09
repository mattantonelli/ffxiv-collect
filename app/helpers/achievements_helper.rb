module AchievementsHelper
  def achievement_category_link(achievement)
    link_to(achievement.category.name,
            achievement_type_path(achievement.type, anchor: achievement.category_id), class: 'unstyled')
  end

  def achievement_type_link(achievement)
    link_to(achievement.type.name, achievement_type_path(achievement.type), class: 'unstyled')
  end

  def achievement_type_category_link(achievement)
    link_to("#{achievement.type.name} / #{achievement.category.name}",
            achievement_type_path(achievement.type, anchor: achievement.category_id), class: 'unstyled')
  end

  def achievement_item_sprite(achievement)
    if achievement.item.unlock.present?
      generic_sprite(achievement.item.unlock_type.downcase.pluralize, achievement.item.unlock)
    else
      sprite(achievement.item, 'achievement_item')
    end
  end

  def achievement_item_link(achievement)
    if achievement.item.unlock.present?
      link_to(achievement.item.unlock.name, achievement.item.unlock)
    else
      if achievement.item.name_en.match?(/Card\z/)
        triple_triad_card_link(achievement.item.name_en)
      else
        achievement.item.name
      end
    end
  end

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
