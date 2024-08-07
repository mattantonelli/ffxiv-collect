module SpellsHelper
  def rank_options
    (1..5).to_a.reverse.map { |x| ["\u2605" * x, x] }
  end

  def spell_sources(spell, limit: 3)
    count = spell.sources.size
    sources = spell.sources.first(limit).map do |source|
      text = source.text

      if text.match?(' / ')
        text.split(' / ')
      else
        # Handle splits for sources with no Enemy details
        ["&nbsp;", text]
      end
    end

    if count == 0
      # Handle spells with no recorded sources
      sources = [["&nbsp;", "&nbsp;"]]
    elsif count > limit
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
    stars(spell.rank)
  end
end
