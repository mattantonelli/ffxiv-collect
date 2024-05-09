$(document).on 'turbolinks:load', ->
  return unless $('.collection').length > 0 || $('#filters').length > 0

  # Collections

  # Redo the table striping as some items may have shifted during the flight
  restripe = ->
    # Skip restripe for Orchestrion Quick Select
    return if $('.quick-select').length > 0 || $('.npcs').length > 0

    $('.collectable:not(.hidden)').show()

    if Cookies.get('owned') == 'owned'
      # Only show owned collectables
      $('.collection').addClass('only-owned')
      $('.collectable:not(.owned)').hide()
    else if Cookies.get('owned') == 'missing'
      # Only show missing collectables
      $('.collection').removeClass('only-owned')
      $('.collectable.owned').hide()
    else
      # Show all collectables
      $('.collection').removeClass('only-owned')

    # Only show/hide tradeables if the filter is available
    if $('#tradeable').length > 0
      if Cookies.get('tradeable') == 'tradeable'
        $('.collectable:not(.tradeable)').hide()
      else if Cookies.get('tradeable') == 'untradeable'
        $('.collectable.tradeable').hide()

    $('tr.collectable:visible').each (index) ->
      $(@).css('background-color', if index % 2 == 0 then 'rgba(0, 0, 0, 0.1)' else 'rgba(0, 0, 0, 0.2)')

    # Update the collection progress bar based on visible collectables, with the exception of special pages
    unless $('.materiel').length > 0
      progress_bar = $('.progress:first > .progress-bar')
      progress_label = $('.progress:first > .progress-label')
      current = $('.owned:not(.hidden)').length
      max = $('tr.collectable:not(.hidden)').length

      if max > 0
        completion = (current / max) * 100
        progress_bar.attr('aria-valuenow', current)
        progress_bar.attr('style', "width: #{completion}%")
        progress_label.text("#{current}/#{max} (#{parseInt(completion)}%)")

    # Update the alternate progress bar based on the *values* of visible collectables
    if $('tr.collectable').data('value')
      progress_bar = $('.progress:eq(1) > .progress-bar')
      progress_label = $('.progress:eq(1) > .progress-label')
      current = max = 0

      $('tr.collectable:not(.hidden)').each (_, collectable) ->
        value = $(collectable).data('value')
        current += value if $(collectable).hasClass('owned')
        max += value

      if max > 0
        completion = (current / max) * 100
        progress_bar.attr('aria-valuenow', current)
        progress_bar.attr('style', "width: #{completion}%")

        text = progress_label.text()
        text = text.replace(/[\d\s,.]+\s/, "#{current.toLocaleString()} ")
        text = text.replace(/(\D+) [\d\s,.]+/, "$1 #{max.toLocaleString()} ")
        progress_label.text(text)

  restripe()

  # Add/remove a collectable from a player's collection
  updateCollection = (collectable) ->
    $.ajax({
      type: 'POST',
      url: collectable.data('path'),
      data: { authenticity_token: window._token },
      error: ->
        alert(I18n.t('alerts.problem_updating'))
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
      collectable.closest('td').attr('data-original-title', "#{I18n.t('acquired')} #{moment.utc().format('MMM DD, YYYY')}")
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
      title = title.replace(/<br>.*?<br>/, '<br>')
        .replace(I18n.t('click.remove'), I18n.t('click.add'))
      collectable.parent().attr('data-original-title', title)
    else
      path = collectable.data('path').replace('add', 'remove')
      collectable.addClass('owned')
      title = title.replace('<br>', "<br>#{I18n.t('acquired')} #{moment.utc().format('MMM DD, YYYY')}<br>")
        .replace(I18n.t('click.add'), I18n.t('click.remove'))
      collectable.parent().attr('data-original-title', title)

    collectable.data('path', path)
    collectable.parent().tooltip('dispose')
    collectable.parent().tooltip('toggle')

    count = collectable.closest('.collapse').find('.owned').length
    header = collectable.closest('.card').find('.card-header > h6')
    header.text(header.text().replace(/\d+/, count))

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

  # Category Buttons

  categories = $('.category-buttons button')
  categories.click ->
    category = $(@).attr('id').match(/\d+$/)[0]
    categories.removeClass('active')
    $(@).addClass('active')
    history.replaceState(history.state, '', "?category=#{category}")

    if category == '0'
      $('.collectable').removeClass('hidden')
      $('.all-hide').addClass('hidden')
    else
      $('.collectable').addClass('hidden')
      $(".collectable.category-#{category}").removeClass('hidden')
      $('.all-hide').removeClass('hidden')

    restripe()

  # Type Buttons

  types = $('.type-buttons button:not("#reset")')
  types.click ->
    $(@).toggleClass('active')
    type = $(@).data('value')
    $(".collectable[data-type='#{type}']").toggleClass('hidden')

    restripe()
    hidden_types = $('.type-buttons button:not(".active")').map ->
      $(@).data('value')
    Cookies.set('hidden_types', hidden_types.get().join(','), { expires: 7300, sameSite: 'Lax' })

  $('.type-buttons button#reset').click ->
    $('.type-buttons button').addClass('active')
    $('.collectable').removeClass('hidden')
    Cookies.remove('hidden_types')
    restripe()

  # Filters

  checkboxValue = (checkbox) ->
    if $(checkbox).prop('checked') then 'hide' else 'show'

  $('#filters-form').submit ->
    premium = $(@).find('#premium')
    limited = $(@).find('#limited')
    ranked_pvp = $(@).find('#ranked_pvp')
    unknown = $(@).find('#unknown')
    gender = $(@).find('#gender')

    refresh = (premium.length > 0 && Cookies.get('premium') != checkboxValue(premium)) ||
      (limited.length > 0 && Cookies.get('limited') != checkboxValue(limited)) ||
      (ranked_pvp.length > 0 && Cookies.get('ranked_pvp') != checkboxValue(ranked_pvp)) ||
      (unknown.length > 0 && Cookies.get('unknown') != checkboxValue(unknown)) ||
      (gender.length > 0 && Cookies.get('gender') != gender.val())

    $(@).find('input[type="checkbox"]').each (_, option) ->
      Cookies.set("#{$(option).attr('id')}", checkboxValue(option), { expires: 7300, sameSite: 'Lax' })

    $(@).find('select').each (_, option) ->
      Cookies.set("#{$(option).attr('id')}", $(option).val(), { expires: 7300, sameSite: 'Lax' })

    $('#filters').modal('hide')

    if refresh
      location.reload()
      false
    else
      restripe()

  $('#filters-reset').click ->
    $('#filters-form select option').prop('selected', false)
    $('#filters-form input[type=checkbox]').prop('checked', false)
    $(@).blur()
    false

  # Remove focus from modal toggle button after showing
  $('.modal').on 'shown.bs.modal', ->
    $('.modal-toggle').one 'focus', ->
      $(@).blur()
