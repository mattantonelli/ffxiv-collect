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

  def patch_options_for_select(patches, selected, expansions: false, all: true)
    # Collect all of the patch numbers and add the Patch text to the display values
    options = @patches.map do |patch|
      ["#{t('patch')} #{patch}", patch]
    end

    # Add special options for searching by exansion
    if expansions
      t('expansions').each do |value, expansion|
        options << [expansion, value]
      end
    end

    # Sort the patches in reverse chronological order
    options.sort_by! { |patch| -patch[1].to_f }

    # Add an All Patches option to the start of the list
    if all
      options.unshift([t('all.patches'), 'all'])
    end

    options_for_select(options, selected)
  end
end
