module RelicsHelper
  def collapse_id(type)
    "collapse-#{type.name.downcase.gsub(' ', '-').delete("+'()")}"
  end

  def relic_type_completion(type, owned_ids)
    relics = type.relics
    "#{(relics.pluck(:id) & owned_ids).size} #{t('of')} #{relics.length} #{t('complete')}"
  end

  def relic_type_completed?(type, owned_ids)
    (type.relics.pluck(:id) - owned_ids).size == 0
  end

  def garo_mounts_completion(mounts, mount_ids)
    "#{(mounts.pluck(:id) & mount_ids).size} #{t('of')} #{mounts.length} #{t('complete')}"
  end

  def garo_mounts_completed?(mounts, mount_ids)
    (mounts.pluck(:id) - mount_ids).size == 0
  end

  def relic_tooltip(relic)
    date = format_date_short(@dates[relic.id])

    text = "<b>#{relic.name}</b><br>"
    text += "<i>#{relic.achievement.name}</i><br>" if relic.achievement_id.present?
    text += "#{t('acquired')} #{format_date_short(@dates[relic.id])}<br>" if date.present?
    text += t('ownership', percent: @owned[relic.id.to_s] || '0%')

    owned = owned?(relic.id)

    if @character&.verified_user?(current_user)
      unless @achievement_ids.include?(relic.achievement_id)
        if owned
          text += "<br>(#{t('click.remove')})"
        else
          text += "<br>(#{t('click.add')})"
        end
      end
    end

    text.html_safe
  end
end
