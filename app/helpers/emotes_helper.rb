module EmotesHelper
  def emote_icon(emote)
    image_tag('blank.png', class: 'emote-icon', style: "background-position: -#{40 * (emote.id - 1)}px 0")
  end
end
