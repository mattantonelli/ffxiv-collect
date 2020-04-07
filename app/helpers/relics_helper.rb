module RelicsHelper
  def relic_completion(relics, owned_ids)
    "#{(relics.pluck(:id) & owned_ids).size} of #{relics.length} complete"
  end

  def relic_completed?(relics, owned_ids)
    (relics.pluck(:id) - owned_ids).size == 0
  end

  def relic_tooltip(relic)
    date = format_date_short(@dates[relic.id])
    text = "<b>#{relic.name}</b><br>"
    text += "Acquired on #{format_date_short(@dates[relic.id])}<br>" if date.present?
    text += "Owned by #{@owned[relic.id.to_s] || '0%'} of players".html_safe
  end
end
