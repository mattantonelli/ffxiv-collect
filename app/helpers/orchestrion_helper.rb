module OrchestrionHelper
  def orchestrion_number(orchestrion)
    if orchestrion.order.present?
      orchestrion.order.rjust(3, '0')
    else
      '-'
    end
  end

  def orchestrion_row_classes(orchestrion, active_category)
    hidden = active_category.present? && orchestrion.category_id != active_category
    "category-#{orchestrion.category_id}#{' hidden' if hidden }"
  end
end
