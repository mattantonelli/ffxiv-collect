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

  def yokai_weapon_owned(weapon, owned_ids)
    owned = owned_ids.include?(weapon.id)
    fa_icon(owned ? 'check' : 'times')
  end
end
