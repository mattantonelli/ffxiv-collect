$ ->
  cache = {}

  removeTooltips = ->
    $('.card-tooltip').remove()

  $('.collectable-tooltip').hover(
    ->
      $collectable = $(this)
      url = $collectable.data('tooltip-url')

      # Try to fetch the tooltip from the cache
      html = cache[url]

      # Remove any existing tooltips just before rendering.
      # Avoids a double render when two requests come back around the same time.
      if html
        removeTooltips()
        $collectable.prepend(html)
      else
        $.get url, (data) ->
          cache[url] = data
          removeTooltips()
          $collectable.prepend(data)
    , ->
      removeTooltips()
  )
