module CollectionsHelper
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
    options_for_select([['Show All', 'all'], ['Only Owned', 'owned'], ['Only Missing', 'missing']], selected)
  end

  def category_row_classes(collectable, active_category, ids = [])
    hidden = active_category.present? && collectable.category_id != active_category
    owned = ids.include?(collectable.id)
    "collectable category-row category-#{collectable.category_id}#{' hidden' if hidden }#{' owned' if owned}"
  end

  def rarity(collectable, numeric: false)
    rarity = @owned.fetch(collectable.id.to_s, '0%')
    numeric ? rarity.delete('%') : rarity
  end

  def td_owned(ids, collectable, manual = true, date = nil)
    owned = ids.include?(collectable.id)
    if manual && @character.verified_user?(current_user)
      content_tag(:td, class: 'text-center', data: { value: owned ? 1 : 0 }) do
        check_box_tag(nil, nil, owned, class: 'own',
                      data: { path: polymorphic_path(collectable, action: owned ? :remove : :add) })
      end
    else
      if owned
        if date.present?
          content_tag(:td, fa_icon('check'), class: 'text-center', data: { value: date.to_i, toggle: 'tooltip' },
                      title: "Achieved on #{format_date_short(date)}")
        else
          content_tag(:td, fa_icon('check'), class: 'text-center', data: { value: 1 })
        end
      else
        content_tag(:td, fa_icon('times'), class: 'text-center', data: { value: 0 })
      end
    end
  end

  def tradeable(collectable)
    can_trade = collectable[:item_id].present?

    if can_trade
      link_to(mogboard_url(collectable[:item_id]), class: 'name', target: '_blank') do
        fa_check(can_trade)
      end
    else
      fa_check(can_trade)
    end
  end

  def achievement_link(source)
    if source.related_id.present?
      link_to(source.related.name, achievement_path(source.related_id))
    else
      source.text
    end
  end

  def mogboard_link(collectable)
    if collectable.item_id.present?
      fa_icon('dollar', data: { toggle: 'tooltip' }, title: 'Tradeable')
    end
  end

  def teamcraft_link(type, text, id = nil)
    if id.present?
      link_to(text, teamcraft_url(type, id), target: '_blank')
    else
      text
    end
  end

  def sources(collectable, list: false)
    sources = collectable.sources.map do |source|
      type = source.type.name

      if type == 'Achievement'
        achievement_link(source)
      elsif Instance.valid_types.include?(type)
        teamcraft_link(:instance, source.related&.name || source.text, source.related_id)
      elsif type == 'Crafting' || type == 'Gathering'
        teamcraft_link(:item, source.text, collectable.item_id)
      elsif type == 'Quest' || type == 'Event'
        teamcraft_link(:quest, source.related&.name || source.text, source.related_id)
      elsif type == 'Feast'
        "The Feast: #{source.text}"
      elsif type == 'Mog Station'
        'Mog Station'
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
end
