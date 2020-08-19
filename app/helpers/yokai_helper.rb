module YokaiHelper
  def yokai_completed?(achievements, owned_ids)
    (achievements.pluck(:id) - owned_ids).size == 0
  end

  def yokai_completion(achievements, owned_ids)
    "#{(achievements.pluck(:id) & owned_ids).size} of #{achievements.length} complete"
  end

  def yokai_missing?(collectable, owned_ids)
    character_selected? && !owned_ids.include?(collectable.id)
  end

  def yokai_name_to_sprite(achievements, name)
    achievement = achievements.find { |achievement| achievement.name_en == "Watch Me If You Can: #{name}" }

    content_tag :div, data: { toggle: 'tooltip' }, title: achievement.name do
      sprite(achievement, 'achievement')
    end
  end
end
