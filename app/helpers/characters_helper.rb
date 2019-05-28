module CharactersHelper
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
end
