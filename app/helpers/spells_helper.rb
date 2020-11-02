module SpellsHelper
  def rank_options
    (1..5).to_a.reverse.map { |x| ["\u2605" * x, x] }
  end

  def spell_enemies(spell)
    enemies = spell.sources.map do |source|
      source.text.split(' / ').first if source.text.match?('/')
    end

    enemies.join('<br>').html_safe
  end

  def spell_locations(spell)
    locations = spell.sources.map do |source|
      source.text.split(' / ').last
    end

    locations.join('<br>').html_safe
  end

  def spell_aspect(spell)
    spell.type.name_en == 'Physical' ? 'Damage' : 'Aspect'
  end

  def spell_rank(spell)
    (fa_icon('star') * spell.rank).html_safe
  end
end
