module CharactersHelper
  def character_free_company_link(character)
    if free_company = character.free_company
      link_to(fa_icon('users', text: free_company.formatted_name),
              free_company_path(character.free_company), class: 'name')
    end
  end

  def server_leaderboards_link(world)
    link_to(fa_icon('globe', text: world), leaderboards_path(q: { server_eq: world }), class: 'name')
  end

  def verified(character, only_verified: false, compact: false)
    if character.verified_user?(current_user)
      if compact
        content_tag(:span, far_icon('check-circle'), title: t('characters.verified'), data: { toggle: 'tooltip' },
                    class: 'text-success')
      else
        content_tag(:span, t('characters.verified'), class: 'badge badge-pill badge-success')
      end
    elsif !only_verified
      content_tag(:span, t('characters.unverified'), class: 'badge badge-pill badge-secondary')
    end
  end

  def last_updated(character)
    content_tag(:span, t('characters.last_updated', timespan: time_ago_in_words(character.last_parsed)), class: 'updated')
  end

  def collectable_name(collection, collectable)
    if collection == 'titles'
      name = title_name(collectable.title)
    else
      name = collectable.name
    end

    if collection == 'achievements' || collection == 'titles'
      content_tag(:span, name, title: collectable.description, data: { toggle: 'tooltip' })
    else
      name
    end
  end

  def collection_name(collection, score: {})
    name = t("#{collection}.title")

    if score.present? && score[:value] == score[:max]
      star = fa_icon('star', class: 'complete')
      name = "#{name} #{star}".html_safe
    end

    name
  end

  def character_relics(character)
    relic_ids = character.relic_ids

    Relic.categories.each_with_object({}) do |category, h|
      ids = Relic.joins(:type).where('relic_types.category = ?', category).pluck(:id)
      owned_relic_ids = (ids & relic_ids)
      h[category] = { count: owned_relic_ids.size, total: ids.size }
      h[category][:ids] = owned_relic_ids if params[:ids].present?
    end
  end

  def statistic_data_rarity(data)
    content_tag(:span, data[:percentage], data: { toggle: 'tooltip' },
                title: "#{number_with_delimiter(data[:count])} #{t('character', count: data[:count].to_i)}")
  end

  def servers_for_select(selected = nil)
    servers = Character.servers_by_data_center.flat_map do |data_center, servers|
      clazz = "dc-#{data_center.downcase}"
      servers.map { |server| [server, { class: clazz }]}
    end

    options_for_select(servers.sort, selected)
  end

  def stat_limit_options(limit)
    options = [10, 20, 50, 100].map do |option|
      ["#{t('leaderboards.top')} #{option}", option]
    end

    options_for_select(options, limit)
  end

  def rankings_link(rankings, character, category, context)
    rank = number_with_delimiter(rankings.dig(category, context))

    case(context)
    when :server
      text = character.server
      query = { server: character.server }
    when :data_center
      text = character.data_center
      query = { data_center: character.data_center }
    else
      text = t("leaderboards.#{context}")
      query = {}
    end

    if category == :achievements
      query[:category] = 'ranked_achievement_points'
    else
      query[:category] = "ranked_#{category}"
    end

    link_to("##{rank} #{text}", leaderboards_path(query), class: 'unstyled')
  end
end
