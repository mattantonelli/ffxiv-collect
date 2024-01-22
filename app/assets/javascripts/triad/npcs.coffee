$(document).on 'turbolinks:load', ->
  return unless $('.npcs').length > 0

  restripe = ->
    # Apply any selected filters
    if $('#hide-completed').prop('checked')
      $('.completed').hide()
    else if $('#hide-defeated').prop('checked')
      $('.defeated').hide()
    else if $('#hide-finished').prop('checked')
      $('.completed.defeated').hide()

    # Update the table row background colors
    $('tbody tr:visible').each (index) ->
      $(this).css('background-color', if index % 2 == 0 then 'rgba(0, 0, 0, 0.1)' else 'rgba(0, 0, 0, 0.2)')

    # Update the progress bar
    progress_bar = $('.progress:first > .progress-bar')
    progress_label = $('.progress:first > .progress-label')
    current = $('tr.collectable.owned:not(.excluded)').length
    max = $('tr.collectable:not(.excluded)').length

    if max > 0
      completion = (current / max) * 100
      progress_bar.attr('aria-valuenow', current)
      progress_bar.attr('style', "width: #{completion}%")
      progress_label.text("#{current}/#{max} (#{parseInt(completion)}%)")

  updateCard = (card) ->
    $.ajax({
      type: 'POST',
      url: card.data('path'),
      data: { authenticity_token: window._token },
      error: ->
        alert(I18n.t('alerts.problem_updating'))
        location.reload()
    })

  $('input[name="display"]').change ->
    $('.npc-row').show()
    if $('#show-all').prop('checked')
      localStorage.setItem('npc-display', 'show-all')
    else if $('#hide-completed').prop('checked')
      localStorage.setItem('npc-display', 'hide-completed')
    else if $('#hide-defeated').prop('checked')
      localStorage.setItem('npc-display', 'hide-defeated')
    else if $('#hide-finished').prop('checked')
      localStorage.setItem('npc-display', 'hide-finished')

    restripe()

  display_setting = localStorage.getItem('npc-display')
  if display_setting != null
    $('#' + display_setting).click()

  $('#npc-search select').change ->
    $('form').submit()

  $('input.own').change ->
    npc = $(this)

    if !this.checked
      path = npc.data('path').replace('remove', 'add')
      npc.closest('tr').removeClass('defeated')
    else
      path = npc.data('path').replace('add', 'remove')
      row = npc.closest('tr')
      row.addClass('defeated')
      if $('#hide-defeated').prop('checked')
        row.hide()

    npc.data('path', path)
    restripe()

  $('.card-toggle').click ->
    card = $(this)

    # Update the users' card collection and toggle the card
    if card.hasClass('owned')
      updateCard(card)
      card.removeClass('owned')
      path = card.data('path').replace('remove', 'add')
    else
      updateCard(card)
      card.addClass('owned')
      path = card.data('path').replace('add', 'remove')

    card.data('path', path)

    # Update the NPC's completion status
    cardList = card.parent()

    if cardList.find('.owned').length == cardList.children().length
      console.log('completed!')
      card.closest('tr').addClass('completed')
    else
      console.log('incomplete')
      card.closest('tr').removeClass('completed')

    restripe()
