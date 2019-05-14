module CollectionsHelper
  def category_row_classes(collectable, active_category, ids = [])
    hidden = active_category.present? && collectable.category_id != active_category
    owned = ids.include?(collectable.id)
    "category-row category-#{collectable.category_id}#{' hidden' if hidden }#{' owned' if owned}"
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
end
