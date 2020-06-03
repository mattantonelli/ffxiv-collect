module CharactersHelper
  def fc_tag_link(character)
    if character.free_company.present?
      link_to("<#{character.free_company.tag}>", free_company_leaderboards_path(character.free_company), class: 'name')
    end
  end

  def verified(character, only_verified = true)
    if character.verified_user?(current_user)
      content_tag(:span, 'Verified', class: 'badge badge-pill badge-success')
    elsif !only_verified
      content_tag(:span, 'Unverified', class: 'badge badge-pill badge-secondary')
    end
  end

  def last_updated(character)
    content_tag(:span, "Last updated #{time_ago_in_words(character.last_parsed)} ago.", class: 'updated')
  end

  def collection_name(collection, score: {})
    if collection == 'spells'
      name = 'Blue Magic'
    else
      name = collection.classify.pluralize
    end

    if score.present? && score[:value] == score[:max]
      star = fa_icon('star', class: 'complete')
      name = "#{name} #{star}".html_safe
    end

    name
  end
end
