module CharactersHelper
  def verified(character)
    if character.verified_user?(current_user)
      content_tag(:span, 'Verified', class: 'badge badge-pill badge-success')
    else
      content_tag(:span, 'Unverified', class: 'badge badge-pill badge-secondary')
    end
  end
end
