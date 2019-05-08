module HairstylesHelper
  def hairstyle_icon(hairstyle, offset = 0)
    path = asset_path("hairstyles/#{hairstyle.id}.png")
    image_tag('blank.png', class: 'hairstyle-icon',
              style: "background: url('#{path}') no-repeat; background-position: -#{96 * offset}px 0;")
  end
end
