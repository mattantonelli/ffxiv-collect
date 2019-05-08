module ArmoiresHelper
  def armoire_icon(armoire)
    image_tag('blank.png', class: 'armoire-icon', style: "background-position: -#{40 * (armoire.id - 1)}px 0")
  end
end
