module MinionsHelper
  def minion_type(minion)
    image_tag('blank.png', class: 'minion-type', style: "background-position: -#{24 * (minion.race_id - 1)}px 0")
  end

  def minion_strength(type, index)
    image_tag('blank.png', class: 'minion-strength', style: "background-position: -#{24 * index}px 0",
              data: { toggle: 'tooltip', title: "#{t('general.effective_against')} #{t('general.'+type)}" })
  end

  def minion_skill_angle(minion)
    index = Minion.angles.index(minion.skill_angle)
    image_tag('blank.png', class: 'minion-skill-angle', style: "background-position: -#{40 * index}px 0")
  end

  def format_skill_description(minion)
    description = minion.skill_description
      .gsub('Duration:', '<br>Duration:')
      .gsub('Activation Delay:', '<br>Activation Delay:')

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
    options_for_select([[t('general.gates'), 'gate'], [t('general.search_eyes'), 'eye'], [t('general.shields'), 'shield'], [t('general.arcana_stones'), 'arcana']], selected)
  end

  def auto_attack(minion)
    minion.area_attack ? t('general.multi_target') : t('general.single_target')
  end
end
