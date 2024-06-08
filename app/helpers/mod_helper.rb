module ModHelper
  def change_diff(change)
    if change.event == 'update'
      list = JSON.parse(change.object_changes).map do |column, diff|
        if column
          "#{column}: #{diff.first} → #{diff.last}"
        end
      end

      list.join('<br>').html_safe
    else
      list = JSON.parse(change.object_changes)

      list.each do |k, v|
        # Find a populated name/text field from the object to display in the log
        if k.match?(/name|text/) && v.any?
          return v[change.event == 'destroy' ? 0 : 1]
        end
      end
    end
  end

  def change_event(change)
    clazz = case(change.event)
            when 'create' then 'text-success'
            when 'update' then 'text-primary'
            when 'destroy' then 'text-danger'
            end

    content_tag :span, change.event, class: clazz
  end

  def change_link(change)
    if change.item_type == 'Source'
      url = polymorphic_url([:mod, change.collectable_type.underscore.to_sym], id: change.collectable_id, action: :edit)
    else
      url = polymorphic_url([:mod, change.item_type.underscore.to_sym], id: change.item_id, action: :edit)
    end

    link_to fa_icon('pen'), url, class: 'btn btn-secondary btn-sm my-1'
  end

  def change_type(change)
    [change.collectable_type, change.item_type].compact.join('/')
  end

  def change_user(change)
    if change.user.present?
      username(change.user)
    else
      'System'
    end
  end

  def gender_options(selected)
    genders = %w(Male Female)
    options_for_select(genders.zip(genders.map(&:downcase)), selected)
  end
end
