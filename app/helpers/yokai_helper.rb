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

  def minion_zones
    {
      'Jibanyan' => ['Central Shroud', 'Lower La Noscea', 'Central Thanalan'],
      'Komasan' => ['East Shroud', 'Western La Noscea', 'Eastern Thanalan'],
      'Whisper' => ['South Shroud', 'Upper La Noscea', 'Southern Thanalan'],
      'Blizzaria' => ['North Shroud', 'Outer La Noscea', 'Middle La Noscea'],
      'Kyubi' => ['Western Thanalan', 'Central Shroud', 'Lower La Noscea'],
      'Komajiro' => ['Central Thanalan', 'East Shroud', 'Western La Noscea'],
      'Manjimutt' => ['Eastern Thanalan', 'South Shroud', 'Upper La Noscea'],
      'Noko' => ['Southern Thanalan', 'North Shroud', 'Outer La Noscea'],
      'Venoct' => ['Middle La Noscea', 'Western Thanalan', 'Central Shroud'],
      'Shogunyan' => ['Lower La Noscea', 'Central Thanalan', 'East Shroud'],
      'Hovernyan' => ['Western La Noscea', 'Eastern Thanalan', 'South Shroud'],
      'Robonyan F-type' => ['Upper La Noscea', 'Southern Thanalan', 'North Shroud'],
      'USApyon' => ['Outer La Noscea', 'Middle La Noscea', 'Western Thanalan'],
      'Lord Enma' => ['Stormblood Zones', '', ''],
      'Lord Ananta' => ['Heavensward Zones', '', ''],
      'Zazel' => ['Heavensward Zones', '', ''],
      'Damona' => ['Stormblood Zones', '', '']
    }
  end
end
