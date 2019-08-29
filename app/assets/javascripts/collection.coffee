$(document).on 'turbolinks:load', ->
  return unless $('.collection').length > 0

  # Collections

  restripe = ->
    return if $('.quick-select').length > 0

    if Cookies.get('owned') == 'owned'
      $('.collection').addClass('only-owned')
      $('.collectable:not(.owned):not(.hidden)').hide()
      $('.collectable.owned:not(.hidden)').show()
    else if Cookies.get('owned') == 'missing'
      $('.collection').removeClass('only-owned')
      $('.collectable:not(.owned):not(.hidden)').show()
      $('.collectable.owned:not(.hidden)').hide()
    else
      $('.collection').removeClass('only-owned')
      $('.collectable:not(.hidden)').show()

    $('tr.collectable:visible').each (index) ->
      $(@).css('background-color', if index % 2 == 0 then 'rgba(0, 0, 0, 0.1)' else 'rgba(0, 0, 0, 0.2)')

    progress = $('.progress-bar:first')
    current = $('.owned:not(.hidden)').length
    max = $('tr.collectable:not(.hidden)').length
    completion = (current / max) * 100

    progress.attr('aria-valuenow', current)
    progress.attr('style', "width: #{completion}%")
    progress.find('b').text("#{current}/#{max} (#{parseInt(completion)}%)")

  restripe()

  updateCollection = (collectable) ->
    $.ajax({
      type: 'POST',
      url: collectable.data('path'),
      data: { authenticity_token: window._token },
      error: ->
        alert('There was a problem updating your collection. Please try again.')
        location.reload()
    })

  $('.sortable').on 'sorted', ->
    restripe()

  $('td input.own').change ->
    collectable = $(this)

    if !this.checked
      updateCollection(collectable)
      path = collectable.data('path').replace('remove', 'add')
      collectable.closest('tr').removeClass('owned')
      collectable.closest('td').attr('data-value', 0)
      collectable.closest('td').next('.comparison').find('.avatar:first').addClass('faded')
    else
      updateCollection(collectable)
      path = collectable.data('path').replace('add', 'remove')
      collectable.closest('td').attr('data-value', 1)
      collectable.closest('td').next('.comparison').find('.avatar:first').removeClass('faded')
      row = collectable.closest('tr')
      row.addClass('owned')

    collectable.data('path', path)
    restripe()

  # Orchestrion quick select

  $('.orchestrion-select input.own').change ->
    collectable = $(this)

    if !this.checked
      updateCollection(collectable)
      path = collectable.data('path').replace('remove', 'add')
      collectable.closest('.collectable').removeClass('owned')
    else
      updateCollection(collectable)
      path = collectable.data('path').replace('add', 'remove')
      collectable.closest('.collectable').addClass('owned')

    collectable.data('path', path)

  # Categories

  buttons = $('.category-buttons button')
  buttons.click ->
    category = $(@).attr('id').match(/\d+$/)[0]
    buttons.removeClass('active')
    $(@).addClass('active')
    history.replaceState({ category: category }, '', "?category=#{category}")

    if category == '0'
      $('.collectable').removeClass('hidden')
      $('.all-hide').addClass('hidden')
    else
      $('.collectable').addClass('hidden')
      $(".collectable.category-#{category}").removeClass('hidden')
      $('.all-hide').removeClass('hidden')

    restripe()

  # Filters

  checkboxValue = (checkbox) ->
    if $(checkbox).prop('checked') then 'hide' else 'show'

  $('#filters-form').submit ->
    refresh = Cookies.get('premium') != checkboxValue($(@).find('#premium')) ||
      Cookies.get('limited') != checkboxValue($(@).find('#limited'))

    $(@).find('input[type="checkbox"]').each (_, option) ->
      Cookies.set("#{$(option).attr('id')}", checkboxValue(option), { expires: 7300 })

    $(@).find('select').each (_, option) ->
      Cookies.set("#{$(option).attr('id')}", $(option).val(), { expires: 7300 })

    restripe()
    $('#filters').modal('hide')
    location.reload() if refresh
    false

  # Remove focus from modal toggle button after showing
  $('.modal').on 'shown.bs.modal', ->
    $('.modal-toggle').one 'focus', ->
      $(@).blur()
