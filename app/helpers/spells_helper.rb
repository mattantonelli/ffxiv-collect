module SpellsHelper
  def rank_options
    (1..5).to_a.reverse.map { |x| ["\u2605" * x, x] }
  end

  def spell_sources(spell, limit: 3)
    sources = spell.sources.first(limit).pluck(:text).map { |source| source.split(' / ') }
    count = spell.sources.size

    if count > limit
      additional = count - limit + 1
      sources.pop
      sources << ["&nbsp;", link_to("#{additional} more #{'source'.pluralize(additional)}",
                                    spell_path(spell), class: 'font-italic')]
    end

    sources.transpose.map { |details| details.join('<br>').html_safe }
  end

  def spell_aspect(spell)
    spell.type.name_en == 'Physical' ? t('spells.damage') : t('spells.aspect')
  end

  def spell_rank(spell)
    (fa_icon('star') * spell.rank).html_safe
  end
end
