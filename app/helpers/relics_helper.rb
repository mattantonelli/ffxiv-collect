module RelicsHelper
  def collapse_id(name)
    "collapse-#{name.downcase.gsub(' ', '-').delete('+')}"
  end

  def relic_completion(relics, owned_ids)
    "#{(relics.pluck(:id) & owned_ids).size} #{t('general.of')} #{relics.length} #{t('general.complete')}"
  end

  def relic_completed?(relics, owned_ids)
    (relics.pluck(:id) - owned_ids).size == 0
  end

  def relic_tooltip(relic, manual_owned: nil)
    date = format_date_short(@dates[relic.id])
    text = "<b>#{relic.name}</b><br>"
    text += "#{t('general.acquired_on')} #{format_date_short(@dates[relic.id])}<br>" if date.present?
    text += t('general.owned_by_players',percent: (@owned[relic.id.to_s] || '0%'))

    if !manual_owned.nil? && @character&.verified_user?(current_user)
      text += "<br>(#{manual_owned ? t('general.click_to_remove') : t('general.click_to_add')})"
    end

    text.html_safe
  end
end
