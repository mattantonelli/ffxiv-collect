$(document).on 'turbolinks:load', ->
  return unless $('.collection').length > 0

  # Collections

  restripe = ->
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

    progress = $('.progress-bar')
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
    else
      updateCollection(collectable)
      path = collectable.data('path').replace('add', 'remove')
      collectable.closest('td').attr('data-value', 1)
      row = collectable.closest('tr')
      row.addClass('owned')
      # if $('#toggle-owned').prop('checked')
      #   row.hide()

    collectable.data('path', path)
    restripe()

  # Orchestrion quick select

  $('.orchestrion-select input.own').change ->
    collectable = $(this)

    if !this.checked
      updateCollection(collectable)
      path = collectable.data('path').replace('remove', 'add')
      collectable.closest('.collectable').addClass('owned')
    else
      updateCollection(collectable)
      path = collectable.data('path').replace('add', 'remove')
      collectable.closest('td').attr('data-value', 1)
      row = collectable.closest('.collectable').removeClass('owned')

    collectable.data('path', path)

  # Categories

  restripe() if $('.categorized').length > 0

  buttons = $('.category-buttons button')
  buttons.click ->
    category = $(@).attr('id').match(/\d+$/)[0]
    buttons.removeClass('active')
    $(@).addClass('active')
    history.replaceState({ category: category }, '', "?category=#{category}")

    if category == '0'
      $('.categorized').fadeOut('fast', ->
        $('.collectable').removeClass('hidden')
        $('.all-hide').addClass('hidden')
        restripe()
        $('.categorized').fadeIn()
      )
    else
      $('.categorized').fadeOut('fast', ->
        $('.collectable').addClass('hidden')
        $(".collectable.category-#{category}").removeClass('hidden')
        $('.all-hide').removeClass('hidden')
        restripe()
        $('.categorized').fadeIn()
      )

  # Filters

  checkboxValue = (checkbox) ->
    if $(checkbox).prop('checked') then 'hide' else 'show'

  $('#filters-form').submit ->
    refresh = Cookies.get('premium') != checkboxValue($(@).find('#premium')) ||
      Cookies.get('limited') != checkboxValue($(@).find('#limited'))

    $(@).find('input[type="checkbox"]').each (_, option) ->
      Cookies.set("#{$(option).attr('id')}", checkboxValue(option))

    $(@).find('select').each (_, option) ->
      Cookies.set("#{$(option).attr('id')}", $(option).val())

    restripe()
    $('#filters').modal('hide')
    location.reload() if refresh
    false

  # Remove focus from modal toggle button after showing
  $('.modal').on 'shown.bs.modal', ->
    $('.modal-toggle').one 'focus', ->
      $(@).blur()
