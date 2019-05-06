module CategoriesHelper
  def category_row_classes(model, active_category)
    hidden = active_category.present? && model.category_id != active_category
    "category-#{model.category_id}#{' hidden' if hidden }"
  end
end
