$ ->
  cache = {}
  $tooltip = $('#collectable-tooltip')

  removeTooltips = ->
    $('.card-tooltip').remove()

  showTooltip = (html) ->
    $tooltip.html(html)
    $tooltip[0].showPopover()

  hideTooltip = ->
    $tooltip[0].hidePopover()

  $('.collectable-tooltip').hover(
    ->
      hideTooltip()
      $collectable = $(this)
      url = $collectable.data('tooltip-url')

      # Anchor the tooltip to the currently hovered collectable
      $tooltip.css('position-anchor', $collectable.css('anchor-name'))

      # Try to fetch the tooltip from the cache
      html = cache[url]

      if html
        showTooltip(html)
      else
        $.get url, (data) ->
          cache[url] = data
          showTooltip(data)
    , ->
      hideTooltip()
  )
