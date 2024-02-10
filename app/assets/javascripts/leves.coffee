$(document).on 'turbolinks:load', ->
  return unless $('.crafting-list').length > 0

  item_categories = ['Carpenter', 'Blacksmith', 'Armorer', 'Goldsmith', 'Leatherworker',
                     'Weaver', 'Alchemist', 'Culinarian', 'Fisher']

  # Toggles the visibility of item-related elements depending on the selected category
  toggleItemElements = ->
    selected = $('.category-buttons .active').text()
    is_item_category = item_categories.includes(selected)
    $('.leve-item').toggle(is_item_category)

  # Check if we need to hide elements on the initial render
  toggleItemElements()

  # When a new category is selected, display the item elements as needed
  $('.category-buttons').click ->
    toggleItemElements()

  # When the Craft List button is clicked, generate a list for the remaining items in
  # the given category using the selected database service
  $('button.crafting-list').click ->
    name = $('.category-buttons .active').text()
    leves = $('tr.collectable:visible:not(.owned)')

    # Collect data on the remaining items
    items = leves.map ->
      id = $(this).data('item-id')
      quantity = $(this).data('item-quantity') || 0
      { id: id, quantity: quantity }

    # Generate the URL for the selected database service
    if $(@).data('database') == 'teamcraft'
      items = items.get().map (item) ->
        "#{item.id},null,#{item.quantity}"

      # Create a base64 encoded string to generate the list
      code = btoa(items.join(';'))
      url = "https://ffxivteamcraft.com/import/#{code}"
    else
      items = items.get().map (item) ->
        if item.quantity > 1
          "item/#{item.id}+#{item.quantity}"
        else
          "item/#{item.id}"

      url = "https://www.garlandtools.org/db/#group/#{name}{#{items.join('|')}}"

    # Open the URL in a new tab and unfocus the button
    window.open(url, '_blank')
    $(@).blur()
