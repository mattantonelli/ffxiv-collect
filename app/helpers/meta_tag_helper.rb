module MetaTagHelper
  def title(text)
    content_for :title, text
  end

  def yield_title(default)
    if content_for?(:title)
      "#{content_for(:title)} - #{default}"
    else
      default
    end
  end

  def description(text)
    content_for :description, text
  end

  def yield_description(default)
    content_for(:description) || default
  end

  def image(path)
    content_for :image, path
  end

  def yield_image(default)
    content_for(:image) || default
  end
end
