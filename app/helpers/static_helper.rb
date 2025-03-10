module StaticHelper
  def faq_refresh_link
    if @character.present?
      link_to('refresh your character', refresh_character_path, method: :post)
    else
      'refresh your character'
    end
  end

  def faq_forum_link
    link_to('Official Forum', 'https://forum.square-enix.com/ffxiv/forums/665', target: '_blank')
  end
end
