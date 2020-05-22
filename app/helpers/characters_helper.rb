module CharactersHelper
  def fc_tag_link(character)
    if character.free_company.present?
      link_to("<#{character.free_company.tag}>", free_company_leaderboards_path(character.free_company), class: 'name')
    end
  end

  def verified(character, only_verified = true)
    if character.verified_user?(current_user)
      content_tag(:span, 'Verified', class: 'badge badge-pill badge-success')
    elsif !only_verified
      content_tag(:span, 'Unverified', class: 'badge badge-pill badge-secondary')
    end
  end

  def last_updated(character)
    content_tag(:span, "Last updated #{time_ago_in_words(character.last_parsed)} ago.", class: 'updated')
  end

  def collection_name(collection, star: true)
    if collection == 'spell'
      name = 'Blue Magic'
    else
      name = collection.capitalize.pluralize
    end

    if star
      if collection == 'minion'
        total = Minion.summonable.count
      else
        total = collection.capitalize.constantize.count
      end

      if @profile.send("#{collection}s_count") == total
        star = fa_icon('star', class: 'complete')
        name = "#{name} #{star}".html_safe
      end
    end

    name
  end

  def most_recent(character, collection)
    character.send(collection).order("character_#{collection}.created_at desc").first(10)
  end
end
