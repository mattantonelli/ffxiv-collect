$(document).on 'turbolinks:load', ->
  return unless $('#orchestrion, #emote, #armoire').length > 0

  buttons = $('.category-buttons button')
  buttons.click ->
    category = $(@).attr('id')
    buttons.removeClass('active')
    $(@).addClass('active')
    history.replaceState({ category: category }, '', "?category=#{category}")

    if category == '0'
      $('table').fadeOut('fast', ->
        $('tbody tr').removeClass('hidden')
        $('table').fadeIn()
      )
    else
      $('table').fadeOut('fast', ->
        $('tbody tr').addClass('hidden')
        $("tbody tr.category-#{category}").removeClass('hidden')
        $('table').fadeIn()
      )
