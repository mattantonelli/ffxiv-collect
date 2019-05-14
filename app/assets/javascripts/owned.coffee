$(document).on 'turbolinks:load', ->
  return unless $('#toggle-owned').length > 0

  restripe = ->
    $('tbody tr:visible').each (index) ->
      $(this).css('background-color', if index % 2 == 0 then 'rgba(0, 0, 0, 0.1)' else 'rgba(0, 0, 0, 0.2)')

  toggleOwned = ->
    if !$('#toggle-owned').prop('checked')
      localStorage.setItem('display-owned', 'true')
      $('.owned:not(.hidden)').show()
    else
      localStorage.setItem('display-owned', 'false')
      $('.owned:not(.hidden)').hide()

    restripe()

  if localStorage.getItem('display-owned') == 'false'
    $('tr.owned').hide()
    $('#toggle-owned').prop('checked', true)
    restripe()

  $('#toggle-owned').change ->
    toggleOwned()

  updateCollection = (collectable) ->
    $.ajax({
      type: 'POST',
      url: collectable.data('path'),
      data: { authenticity_token: window._token },
      error: ->
        alert('There was a problem updating your collection. Please try again.')
        location.reload()
    })

  $('input.own').change ->
    collectable = $(this)

    if !this.checked
      updateCollection(collectable)
      path = collectable.data('path').replace('remove', 'add')
      collectable.closest('tr').removeClass('owned')
      collectable.closest('td').attr('data-value', 0)
    else
      updateCollection(collectable)
      path = collectable.data('path').replace('add', 'remove')
      collectable.closest('td').attr('data-value', 1)
      row = collectable.closest('tr')
      row.addClass('owned')
      if $('#toggle-owned').prop('checked')
        row.hide()

    collectable.data('path', path)
    restripe()

  restripe() if $('.categorized').length > 0

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
        toggleOwned()
        $('table').fadeIn()
      )
    else
      $('table').fadeOut('fast', ->
        $('tbody tr').addClass('hidden')
        $("tbody tr.category-#{category}").removeClass('hidden')
        $('.all-hide').removeClass('hidden')
        toggleOwned()
        $('table').fadeIn()
      )
