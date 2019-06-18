module TitlesHelper
  def title_name(title)
    if title.name == title.female_name
      title.name
    else
      "#{title.name}<br>#{title.female_name}".html_safe
    end
  end
end
