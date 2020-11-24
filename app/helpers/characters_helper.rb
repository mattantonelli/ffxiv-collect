module CharactersHelper
  def fc_tag_link(character)
    if character.free_company.present?
      link_to("<#{character.free_company.tag}>", free_company_leaderboards_path(character.free_company), class: 'name')
    end
  end

  def verified(character, only_verified = true)
    if character.verified_user?(current_user)
      content_tag(:span, t('characters.verified'), class: 'badge badge-pill badge-success')
    elsif !only_verified
      content_tag(:span, t('characters.unverified'), class: 'badge badge-pill badge-secondary')
    end
  end

  def last_updated(character)
    content_tag(:span, t('characters.last_updated', timespan: time_ago_in_words(character.last_parsed)), class: 'updated')
  end

  def collection_name(collection, score: {})
    name = t("#{collection}.title")

    if score.present? && score[:value] == score[:max]
      star = fa_icon('star', class: 'complete')
      name = "#{name} #{star}".html_safe
    end

    name
  end
end
