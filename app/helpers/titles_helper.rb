module TitlesHelper
  def title_name(title)
    if title.name == title.female_name
      title.name
    else
      "#{title.name} #{gender_symbol('male')}<br>" \
        "#{title.female_name} #{gender_symbol('female')}".html_safe
    end
  end
end
