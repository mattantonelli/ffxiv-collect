module CollectionsHelper
  def collectable_classes(collectable)
    "collectable#{' owned' if owned?(collectable.id)}#{' tradeable' if tradeable?(collectable)}"
  end

  def collectable_name_link(collectable)
    link_to(collectable.name, polymorphic_path(collectable), class: 'name')
  end

  def collectable_image(collectable)
    type = collectable.class.to_s

    case type
    when 'Orchestrion'
      image_tag('orchestrion.png')
    when 'Hairstyle'
      hairstyle_sample_image(collectable)
    when 'Mount', 'Minion'
      sprite(collectable, "#{type.downcase.pluralize}-small")
    else
      sprite(collectable, type.downcase)
    end
  end

  def collectable_owned?(collectable)
    @character.present? && @owned_ids[collectable_type(collectable)].include?(collectable.id)
  end

  def collectable_type(collectable)
    collectable.class.to_s.downcase.pluralize.to_sym
  end

  def format_skill_description(description)
    format_text(description.gsub("\n", '<br>'))
  end

  def sprite(collectable, model)
    id = model == 'achievement' ? collectable.icon_id : collectable.id
    image_tag('blank.png', class: "#{model} #{model}-#{id}")
  end

  def character_selected?
    @character.present?
  end

  def collection_progress(collection, ids)
    if collection.length > 0
      render 'shared/progress', value: (collection.map(&:id) & ids).size, min: 0, max: collection.length
    end
  end

  def ownership_options(selected = nil)
    options_for_select([[t('show_all'), 'all'], [t('only.owned'), 'owned'], [t('only.missing'), 'missing']], selected)
  end

  def gender_filter_options(selected = nil)
    options_for_select([[t('all.genders'), 'all'], [t('hide.male'), 'male'], [t('hide.female'), 'female'],
                        [t('characters.usable'), 'character']], selected)
  end

  def tradeable_options(selected = nil)
    options_for_select([[t('any_tradeable'), 'all'], [t('only.tradeable'), 'tradeable'],
                        [t('only.untradeable'), 'untradeable']], selected)
  end

  def category_row_classes(collectable, active_category)
    hidden = active_category.present? && collectable.category_id != active_category
    "#{collectable_classes(collectable)} category-row category-#{collectable.category_id}#{' hidden' if hidden }"
  end

  def rarity(collectable, numeric: false)
    if @owned.present?
      rarity = @owned.fetch(collectable.id.to_s, '0%')
    else
      rarity = Redis.current.hget(collectable.class.to_s.downcase.pluralize, collectable.id) || '0%'
    end

    numeric ? rarity.delete('%') : rarity
  end

  def owned?(id)
    @collection_ids.include?(id)
  end

  def ownership(character, collectable)
    if character.present?
      owned = collectable.characters.include?(character)

      content_tag(:span, data: { toggle: 'tooltip' }, title: t(owned ? 'characters.owned' : 'characters.not_owned')) do
        fa_check(owned, false)
      end
    end
  end

  def td_owned(collectable)
    date = @dates&.dig(collectable.id)
    manual = !(collectable.class == Mount || collectable.class == Minion)
    owned = @collection_ids&.include?(collectable.id) ||
      (@owned_ids.present? && @owned_ids[collectable_type(collectable)].include?(collectable.id))

    if manual && @character.verified_user?(current_user)
      content_tag(:td, class: 'text-center',
                  data: { value: owned ? 1 : 0, toggle: 'tooltip', placement: 'right' },
                  title: ("#{t('acquired')} #{format_date_short(date)}" if date.present?) ) do
        check_box_tag(nil, nil, owned, class: 'own',
                      data: { path: polymorphic_path(collectable, action: owned ? :remove : :add) })
      end
    else
      if owned
        if date.present?
          content_tag(:td, fa_icon('check'), class: 'text-center',
                      data: { value: 1, toggle: 'tooltip', placement: 'right' },
                      title: "#{t('acquired')} #{format_date_short(date)}")
        else
          content_tag(:td, fa_icon('check'), class: 'text-center', data: { value: 1 })
        end
      else
        content_tag(:td, fa_icon('times'), class: 'text-center', data: { value: 0 })
      end
    end
  end

  def td_comparison(collectable)
    owned = [@collection_ids.include?(collectable.id), @comparison_ids.include?(collectable.id)]
    value = owned.reverse.map { |own| own ? 1 : 0 }.join.to_i(2) # Convert ownership to sortable bitstring

    content_tag(:td, class: 'comparison no-wrap text-center px-2', data: { value: value }) do
      [
        image_tag(@character.avatar, class: "avatar mr-2#{' faded' unless owned[0]}"),
        image_tag(@comparison.avatar, class: "avatar#{' faded' unless owned[1]}")
      ].join.html_safe
    end
  end

  def tradeable(collectable)
    can_trade = tradeable?(collectable)

    if can_trade
      data_center = @character&.data_center&.downcase || 'primal'
      price = Redis.current.hget("prices-#{data_center}", collectable.item_id)

      link_to(universalis_url(collectable[:item_id]), class: 'name', target: '_blank',
              data: { toggle: 'tooltip', html: true }, title: price_tooltip(collectable, price)) do
        fa_check(can_trade)
      end
    else
      fa_check(can_trade)
    end
  end

  def tradeable?(collectable)
    collectable[:item_id].present?
  end

  def sort_value(collectable)
    patch = collectable.patch || '2.0'
    order = collectable[:order] || collectable[:id]
    "#{patch.ljust(4, '0')}#{order}"
  end

  def price_sort_value(collectable)
    if price = @prices[collectable.item_id]
      price['price']
    else
      '999999999'
    end
  end

  def achievement_link(source)
    if source.related_id.present?
      link_to(source.related.name, achievement_path(source.related_id))
    else
      source.text
    end
  end

  def market_link(collectable)
    if tradeable?(collectable)
      link_to(fa_icon('dollar-sign'), universalis_url(collectable.item_id), target: '_blank',
              data: { toggle: 'tooltip', html: true }, title: price_tooltip(collectable))
    end
  end

  def materiel_container(collectable)
    return nil unless tradeable?(collectable)

    case collectable.patch
    when /^[23]/ then '3.0'
    when /^4/ then '4.0'
    else nil
    end
  end

  def materiel_sort_value(collectable)
    collectable.patch if materiel_container(collectable).present?
  end

  def materiel_icon(collectable)
    if number = materiel_container(collectable)
      content_tag(:span, fa_icon('box'), data: { toggle: 'tooltip' }, title: t("materiel.#{number[0]}"))
    end
  end

  def database_link(type, text, id = nil)
    return text unless id.present?

    if current_user&.database == 'teamcraft'
      teamcraft_link(type, text, id)
    else
      garland_tools_link(type, text, id)
    end
  end

  def garland_tools_link(type, text, id)
    link_to(text, garland_tools_url(type, id), target: '_blank')
  end

  def teamcraft_link(type, text, id)
    link_to(text, teamcraft_url(type, id), target: '_blank')
  end

  def sources(collectable, list: false)
    if collectable.class == Orchestrion
      return [format_text_long(collectable.description), collectable.details].compact.join('<br>').html_safe
    end

    sources = collectable.sources.flat_map do |source|
      type = source.type.name

      if type == 'Achievement'
        achievement_link(source)
      elsif Instance.valid_types.include?(type)
        database_link(:instance, source.related&.name || source.text, source.related_id)
      elsif type == 'Crafting' || type == 'Gathering'
        database_link(:item, source.text, collectable.item_id)
      elsif type == 'Quest' || type == 'Event'
        database_link(:quest, source.related&.name || source.text, source.related_id)
      elsif type == 'Mog Station'
        'Mog Station'
      elsif type == 'Voyages'
        if list
          type, texts = source.text.split(' - ')
          texts.split(', ').map { |text| "#{type} - #{text}"}
        else
          texts = source.text.split(', ')
          if texts.size > 3
            "#{source.text.split(', ').first(3).join(', ')}..."
          else
            source.text
          end
        end
      else
        source.text
      end
    end

    if list && sources.size > 1
      content_tag(:ul, class: 'list-unstyled mb-0') do
        sources.each do |source|
          concat content_tag(:li, "\u2022 #{source}".html_safe)
        end
      end
    else
      sources.join('<br>').html_safe
    end
  end

  private
  def price_tooltip(collectable, data = nil)
    begin
      if data.present?
        price = JSON.parse(data)
      else
        price = @prices[collectable.item_id]
      end

      "<b>#{t('prices.price')}:</b> #{number_with_delimiter(price['price'])} Gil<br>" \
        "<b>#{t('prices.world')}:</b> #{price['world']}<br>" \
        "<b>#{t('prices.updated')}:</b> #{price['last_updated']}"
    rescue
    end
  end
end
