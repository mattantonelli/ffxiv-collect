module MinionsHelper
  def minion_type(minion)
    image_tag('blank.png', class: 'minion-type', style: "background-position: -#{24 * (minion.race_id - 1)}px 0")
  end

  def minion_strength(type, index)
    name = t("verminion.#{type.parameterize(separator: '_')}")
    image_tag('blank.png', class: 'minion-strength', style: "background-position: -#{24 * index}px 0",
              data: { toggle: 'tooltip', title: "#{t('verminion.effective')} #{name}" })
  end

  def minion_skill_angle(minion)
    index = Minion.angles.index(minion.skill_angle)
    image_tag('blank.png', class: 'minion-skill-angle', style: "background-position: -#{40 * index}px 0")
  end

  def format_skill_description(minion)
    description = minion.skill_description
      .gsub(/(\*\*(.+)\*\*)/, '<br>\1')

    format_text(description)
  end

  def speed(minion)
    "#{fa_icon('star') * minion.speed}#{fa_icon('star-o') * (4 - minion.speed)}".html_safe
  end

  def speed_options
    (1..4).to_a.reverse.map { |x| ["\u2605" * x, x] }
  end

  def strengths(minion)
    if minion.strengths.values.any?
      strengths = minion.strengths.each_with_index.map do |(type, strong), i|
        if strong
          minion_strength(type, i)
        end
      end

      strengths.join.html_safe
    end
  end

  def strengths_count(minion)
    minion.strengths.values.count(true)
  end

  def strength_options(selected)
    options_for_select([[t('verminion.gates'), 'gate'], [t('verminion.search_eyes'), 'eye'],
                        [t('verminion.shields'), 'shield'], [t('verminion.arcana_stones'), 'arcana']], selected)
  end

  def auto_attack(minion)
    minion.area_attack ? t('verminion.multi_target') : t('verminion.single_target')
  end
end
