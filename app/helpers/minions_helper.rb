module MinionsHelper
  def minion_icon(minion)
    image_tag('blank.png', class: 'minion-icon', style: "background-position: -#{40 * (minion.id - 1)}px 0")
  end

  def minion_large(minion)
    image_tag('blank.png', class: 'minion-large', style: "background-position: -#{192 * (minion.id - 1)}px 0")
  end

  def minion_footprint(minion)
    image_tag('blank.png', class: 'minion-footprint', style: "background-position: -#{128 * (minion.id - 1)}px 0")
  end

  def minion_type(minion)
    image_tag('blank.png', class: 'minion-type', style: "background-position: -#{24 * (minion.race_id - 1)}px 0")
  end

  def minion_strength(type, index)
    image_tag('blank.png', class: 'minion-strength', style: "background-position: -#{24 * index}px 0",
              data: { toggle: 'tooltip', title: "Effective against #{type}" })
  end

  def minion_skill_angle(minion)
    index = Minion.angles.index(minion.skill_angle)
    image_tag('blank.png', class: 'minion-skill-angle', style: "background-position: -#{40 * index}px 0")
  end

  def speed(minion)
    "#{fa_icon('star') * minion.speed}#{fa_icon('star-o') * (4 - minion.speed)}".html_safe
  end

  def auto_attack(minion)
    @minion.area_attack ? 'Multi-target' : 'Single-target'
  end
end
