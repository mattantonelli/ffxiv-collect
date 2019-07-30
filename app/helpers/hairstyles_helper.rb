module HairstylesHelper
  def hairstyle_image(hairstyle, offset = 0)
    path = image_path("hairstyles/#{hairstyle.id}.png")
    image_tag('blank.png', class: 'hairstyle',
              style: "background: url('#{path}') no-repeat; background-position: -#{96 * offset}px 0;")
  end

  def hairstyle_sample_image(hairstyle)
    safe_image_tag("hairstyles/samples/#{hairstyle.id}.png", class: 'hairstyle-small')
  end
end
