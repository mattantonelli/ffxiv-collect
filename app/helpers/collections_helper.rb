module CollectionsHelper
  def collectable_classes(collectable, generic: false)
    if generic
      "collectable#{' owned' if generic_collectable_owned?(collectable)}#{' tradeable' if collectable.tradeable?}"
    else
      "collectable#{' owned' if owned?(collectable.id)}#{' tradeable' if collectable.tradeable?}"
    end
  end

  def collectable_name_link(collectable)
    link_to(collectable.name, polymorphic_path(collectable), class: 'name')
  end

  def collectable_image(collectable)
    type = collectable.class.to_s

    case type
    when 'Frame'
      image_tag('frame.png')
    when 'Orchestrion'
      image_tag('orchestrion.png')
    when 'Hairstyle'
      hairstyle_sample_image(collectable)
    when 'Mount', 'Minion', 'Fashion'
      sprite(collectable, "#{type.downcase.pluralize}-small")
    else
      sprite(collectable, type.downcase)
    end
  end

  def collectable_image_link(collectable)
    link_to(polymorphic_path(collectable)) do
      collectable_image(collectable)
    end
  end

  def generic_collectable_owned?(collectable)
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
    # Set the count and percentage from the full ownership dataset if we have it,
    # otherwise fetch the values from Redis for the given collectable.
    if @owned.present?
      count = @owned.dig(:count, collectable.id.to_s).to_i
      percentage = @owned.dig(:percentage, collectable.id.to_s) || '0%'
    else
      key = collectable.class.to_s.downcase.pluralize
      count = Redis.current.hget("#{key}-count", collectable.id).to_i
      percentage = Redis.current.hget(key, collectable.id) || '0%'
    end

    if numeric
      # Numeric returns just the count for sorting
      count
    else
      # Otherwise render a fancy tooltip with the percentage and the count
      content_tag(:span, percentage, data: { toggle: 'tooltip' },
                  title: "#{number_with_delimiter(count)} #{t('character', count: count)}")
    end
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
    manual = ![Achievement, Mount, Minion].include?(collectable.class)
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
    if collectable.tradeable?
      data_center = @character&.data_center&.downcase || 'primal'
      price = Redis.current.hget("prices-#{data_center}", collectable.item_id)

      link_to(universalis_url(collectable[:item_id]), class: 'name', target: '_blank',
              data: { toggle: 'tooltip', html: true }, title: price_tooltip(collectable, price)) do
        fa_check(true)
      end
    else
      fa_check(false)
    end
  end

  def sort_value(collectable)
    patch = collectable.patch || '2.0'
    order = collectable[:order] || collectable[:id]
    "#{patch.ljust(4, '0')}#{order}"
  end

  def price_sort_value(collectable)
    if collectable.item_id.present?
      @prices.dig(collectable.item_id, 'price') || '9999999998'
    else
      '9999999999'
    end
  end

  def achievement_link(source)
    if source.related_id.present?
      link_to(source.related.name, achievement_path(source.related_id), title: source.related.description,
              data: { toggle: 'tooltip' })
    else
      source.text
    end
  end

  def market_link(collectable)
    if collectable.tradeable?
      link_to(fa_icon('dollar-sign'), universalis_url(collectable.item_id), target: '_blank',
              data: { toggle: 'tooltip', html: true }, title: price_tooltip(collectable))
    end
  end

  def materiel_container(collectable)
    return nil unless collectable.tradeable?

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

  def triple_triad_card_link(name)
    link_to(name, "https://triad.raelys.com/cards/#{name.sub(/Card\z/, '')}", target: '_blank')
  end

  def source_sort_value(collectable)
    if collectable.class == Achievement
      "Achievement #{collectable.description}"
    else
      source = collectable.sources&.first
      "#{source&.type&.name} #{source&.text}"
    end
  end

  def sources(collectable, list: false)
    sources = collectable.sources.flat_map do |source|
      type = source.type.name_en

      if type == 'Achievement'
        content = achievement_link(source)
      elsif Instance.valid_types.include?(type)
        content = database_link(:instance, source.related&.name || source.text, source.related_id)
      elsif type == 'Crafting' || type == 'Gathering'
        content = database_link(:item, source.text, collectable.item_id)
      elsif type == 'Quest' || type == 'Event'
        content = database_link(:quest, source.related&.name || source.text, source.related_id)
      elsif type == 'Online Store'
        content = 'Online Store'
      elsif type == 'Voyages'
        if list
          voyage_type, texts = source.text.split(' - ')
          content = texts.split(', ').map { |text| "#{voyage_type} - #{text}"}.join('<br>').html_safe
        else
          texts = source.text.split(', ')
          if texts.size > 3
            content = "#{source.text.split(', ').first(3).join(', ')}..."
          else
            content = source.text
          end
        end
      else
        content = source.text
      end

      { type: type, content: content }
    end

    content_tag(:div, class: 'sources') do
      sources.each do |source|
        concat(content_tag(:span, source[:content], class: "source source-#{source[:type].parameterize(separator: '-')}"))
      end
    end
  end

  def active_filters
    available_filters.each_with_object({}) do |filter, h|
      value = cookies[filter]

      unless value.nil? || value == 'show' || value == 'all'
        h[filter] = value
      end
    end
  end

  def available_filters
    # If the controller/action are passed in from the filter form submission, use those.
    # Otherwise, use the current controller/action.
    filter_controller = params[:filter_controller] || controller_name
    filter_action = params[:filter_action] || action_name

    # Non-standard filters are set here
    filters =
      case filter_controller
      when 'achievements'
        if action_name == 'index'
          %i(limited)
        else
          %i(owned limited ranked_pvp)
        end
      when 'groups', 'free_companies'
        %i(premium limited ranked_pvp unknown)
      when 'latest'
        %i(owned tradeable gender premium limited unknown)
      when 'tomestones'
        %i(owned)
      when 'tools'
        case filter_action
        when 'gemstones'
          %i(owned tradeable)
        else
          %i(owned)
        end
      else
        # Otherwise, filters are provided by the model
        filter_controller.classify.constantize.available_filters
      end

    filters.delete(:owned) unless @character.present? || params[:character_id].present?
    filters
  end

  def filter_icon(filter, value)
    icon = case filter
           when :owned
             case value
             when 'owned' then 'check'
             when 'missing' then 'times'
             end
           when :tradeable
             'dollar-sign'
           when :gender
             if value == 'character'
               case @character&.gender
               when 'male' then 'mars'
               when 'female' then 'venus'
               end
             else
               case value
               when 'male' then 'venus'
               when 'female' then 'mars'
               end
             end
           when :premium
             'money-bill-alt'
           when :limited
             'clock'
           when :ranked_pvp
             'medal'
           when :unknown
             'question'
           end

    fa_icon(icon) if icon.present?
  end

  def patch_options_for_select(patches, selected, expansions: false, all: true)
    # Collect all of the patch numbers and add the Patch text to the display values
    options = patches.map do |patch|
      ["#{t('patch')} #{patch}", patch]
    end

    # Add special options for searching by exansion
    if expansions
      t('expansions').each do |value, expansion|
        options << [expansion, value]
      end
    end

    # Sort the patches in reverse chronological order
    options.sort_by! { |patch| -patch[1].to_f }

    # Add an All Patches option to the start of the list
    if all
      options.unshift([t('all.patches'), 'all'])
    end

    options_for_select(options, selected)
  end

  private
  def price_tooltip(collectable, data = nil)
    begin
      if data.present?
        # Use explicitly provided price data if available
        price = JSON.parse(data)
      else
        # Otherwise, it should be available from a hash
        price = @prices[collectable.item_id]
      end

      # Do not render tooltips for items without listings
      return unless price['price'].present?

      "<b>#{t('prices.price')}:</b> #{number_with_delimiter(price['price'])} Gil<br>" \
        "<b>#{t('prices.world')}:</b> #{price['world']}<br>" \
        "<b>#{t('prices.updated')}:</b> #{price['last_updated']}"
    rescue
    end
  end
end
