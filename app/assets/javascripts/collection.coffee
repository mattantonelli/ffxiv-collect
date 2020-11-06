$(document).on 'turbolinks:load', ->
  return unless $('.collection').length > 0 || $('#filters').length > 0

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

    if max > 0
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

  # Manual collection ownership toggle

  $('td input.own').change ->
    collectable = $(this)
    updateCollection(collectable)

    if !this.checked
      path = collectable.data('path').replace('remove', 'add')
      collectable.closest('tr').removeClass('owned')
      collectable.closest('td').attr('data-value', 0)
      collectable.closest('td').tooltip('disable')
      collectable.closest('td').tooltip('dispose')
      collectable.closest('td').next('.comparison').find('.avatar:first').addClass('faded')
    else
      path = collectable.data('path').replace('add', 'remove')
      collectable.closest('tr').addClass('owned')
      collectable.closest('td').attr('data-value', 1)
      collectable.closest('td').attr('data-original-title', "Acquired on #{moment.utc().format('MMM DD, YYYY')}")
      collectable.closest('td').tooltip('enable')
      collectable.closest('td').next('.comparison').find('.avatar:first').removeClass('faded')

    collectable.data('path', path)
    restripe()

  # Manual generic item ownership toggle

  $('.item.own').click ->
    collectable = $(this)
    title = collectable.parent().attr('data-original-title')
    updateCollection(collectable)

    if collectable.hasClass('owned')
      path = collectable.data('path').replace('remove', 'add')
      collectable.removeClass('owned')
      title = title.replace(/Acquired.*?<br>/, '').replace('remove', 'add')
      collectable.parent().attr('data-original-title', title)
    else
      path = collectable.data('path').replace('add', 'remove')
      collectable.addClass('owned')
      title = title.replace('Owned by', "Acquired on #{moment.utc().format('MMM DD, YYYY')}<br>Owned by")
        .replace('add', 'remove')
      collectable.parent().attr('data-original-title', title)

    collectable.data('path', path)
    collectable.parent().tooltip('dispose')
    collectable.parent().tooltip('toggle')

    count = collectable.closest('.collapse').find('.owned').length
    header = collectable.closest('.card').find('.card-header > h6')
    header.text(header.text().replace(/\d+ of/, "#{count} of"))

    if count == collectable.closest('.collapse').find('.item').length
      header.addClass('complete')
    else
      header.removeClass('complete')

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
    premium = $(@).find('#premium')
    limited = $(@).find('#limited')
    gender  = $(@).find('#gender')

    refresh = (premium.length > 0 && Cookies.get('premium') != checkboxValue(premium)) ||
      (limited.length > 0 && Cookies.get('limited') != checkboxValue(limited)) ||
      (gender.length > 0 && Cookies.get('gender') != gender.val())

    $(@).find('input[type="checkbox"]').each (_, option) ->
      Cookies.set("#{$(option).attr('id')}", checkboxValue(option), { expires: 7300 })

    $(@).find('select').each (_, option) ->
      Cookies.set("#{$(option).attr('id')}", $(option).val(), { expires: 7300 })

    $('#filters').modal('hide')

    if refresh
      location.reload()
    else
      restripe()

    false

  # Remove focus from modal toggle button after showing
  $('.modal').on 'shown.bs.modal', ->
    $('.modal-toggle').one 'focus', ->
      $(@).blur()
