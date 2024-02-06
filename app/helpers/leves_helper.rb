module LevesHelper
  def leve_item(leve)
    item = leve.item&.name
    return nil unless item.present?

    if leve.item_quantity > 1
      "#{item} (x#{leve.item_quantity})"
    else
      item
    end
  end
end
