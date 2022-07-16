module StaticHelper
  def faq_refresh_link
    if @character.present?
      link_to('refresh your character', refresh_character_path, method: :post)
    else
      'refresh your character'
    end
  end
end
