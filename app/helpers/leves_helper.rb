module LevesHelper
  def leve_item(leve)
    item = leve.item&.name
    return nil unless item.present?

    if leve.item_quantity > 1
      text = "#{item} (x#{leve.item_quantity})"
    else
      text = item
    end

    database_link('item', text, leve.item_id) do
      content_tag(:div, class: 'd-flex align-items-center') do
        content_tag(:div, sprite(leve.item, 'leve_item'), class: 'hide-sm') + text
      end
    end
  end
end
