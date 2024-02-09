$(document).on 'turbolinks:load', ->
  return unless $('.crafting-list').length > 0

  $('.category-buttons').click ->
    name = $('.category-buttons .active').text()

  $('button.crafting-list').click ->
    name = $('.category-buttons .active').text()
    leves = $('tr.collectable:visible:not(.owned)')

    items = leves.map ->
      item_id = $(this).data('item-id')
      quantity = $(this).data('item-quantity') || 0
      { item_id: item_id, quantity: quantity }

    if $(@).data('database') == 'teamcraft'
    else
      items = items.get().map (item) ->
        if item.quantity > 1
          "item/#{item.item_id}+#{item.quantity}"
        else
          "item/#{item.item_id}"

      url = "https://www.garlandtools.org/db/#group/#{name}{#{items.join('|')}}"

    window.open(url, '_blank')
    $(@).blur()
