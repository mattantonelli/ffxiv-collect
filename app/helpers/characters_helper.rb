module CharactersHelper
  def verified(character, only_verified = true)
    if character.verified_user?(current_user)
      content_tag(:span, 'Verified', class: 'badge badge-pill badge-success')
    elsif !only_verified
      content_tag(:span, 'Unverified', class: 'badge badge-pill badge-secondary')
    end
  end
end
