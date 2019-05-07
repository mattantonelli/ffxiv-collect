module BardingsHelper
  def barding_icon(barding)
    image_tag('blank.png', class: 'barding-icon', style: "background-position: -#{40 * (barding.id - 1)}px 0")
  end
end
