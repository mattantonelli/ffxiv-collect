module FacewearHelper
  def facewear_image(facewear, offset = 0)
    path = image_path("facewear/#{facewear.id}.png")
    image_tag('blank.png', class: 'facewear',
              style: "background: url('#{path}') no-repeat; background-position: -#{80 * offset}px 0;")
  end

  def facewear_sample_image(facewear)
    safe_image_tag("facewear/samples/#{facewear.id}.png", class: 'facewear-small')
  end
end
