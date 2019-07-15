module TitlesHelper
  def title_name(title)
    if title.name == title.female_name
      title.name
    else
      "#{title.name}<br>#{title.female_name}".html_safe
    end
  end

  def titles_progress(titles, achievement_ids)
    render 'shared/progress', value: (titles.map(&:achievement_id) & achievement_ids).size, min: 0, max: titles.length
  end
end
