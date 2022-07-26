module HairstylesHelper
  def hairstyle_image(hairstyle, offset = 0)
    path = image_path("hairstyles/#{hairstyle.id}.png")
    image_tag('blank.png', class: 'hairstyle',
              style: "background: url('#{path}') no-repeat; background-position: -#{192 * offset}px 0;")
  end

  def hairstyle_sample_image(hairstyle)
    safe_image_tag("hairstyles/samples/#{hairstyle.id}.png", class: 'hairstyle-small')
  end

  def hrothable(hairstyle)
    if hairstyle.hrothable?
      content_tag(:span, fa_icon('paw'), data: { toggle: 'tooltip' }, title: t('hairstyles.hrothgar'))
    end
  end

  def vierable(hairstyle)
    if hairstyle.vierable?
      content_tag(:span, fa_icon('carrot'), data: { toggle: 'tooltip' }, title: t('hairstyles.viera'))
    end
  end
end
