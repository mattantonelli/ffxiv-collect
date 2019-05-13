$(document).on 'turbolinks:load', ->
  return unless $('.categorized').length > 0

  buttons = $('.category-buttons button')
  buttons.click ->
    category = $(@).attr('id')
    buttons.removeClass('active')
    $(@).addClass('active')
    history.replaceState({ category: category }, '', "?category=#{category}")

    if category == '0'
      $('table').fadeOut('fast', ->
        $('tbody tr').removeClass('hidden')
        $('.all-hide').addClass('hidden')
        $('table').fadeIn()
      )
    else
      $('table').fadeOut('fast', ->
        $('tbody tr').addClass('hidden')
        $("tbody tr.category-#{category}").removeClass('hidden')
        $('.all-hide').removeClass('hidden')
        $('table').fadeIn()
      )
