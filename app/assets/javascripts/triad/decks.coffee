$(document).on 'turbolinks:load', ->
  return unless $('#deck').length > 0

  updateView = (source) ->
    card_ids = $('#deck_card_ids').val()

    $.ajax({
      type: 'GET',
      url: $('.search-form').attr('action'),
      data: $('.search-form').serialize() + "&card_ids=#{card_ids}&source=#{source}",
      dataType: 'script',
      success: ->
        switch(source)
          when 'deck'
            $('.card-large').tooltip()
            addDeckListeners()
          when 'search'
            addSearchListeners()
            $('table').fadeIn(300)
            $.bootstrapSortable({ applyLast: true })

        $('.search-form').find(':input').prop('disabled', false)
    })

  addCard = (id) ->
    ids = $('#deck_card_ids').val().split(',').filter(Boolean)
    ids.push(id)
    $('#deck_card_ids').val(ids.join(','))

    button = $(".deck-toggle[data-card-id=#{id}]")
    if button != undefined
      button.html('<i class="fa fa-minus"></i> Remove')
      button.find('i').attr('class', 'fa fa-minus')
      button.attr('data-action', 'remove')

    if ids.length >= 5
      $('.deck-toggle[data-action=add]').prop('disabled', true)
      $('form.deck-submit input[type=submit]').prop('disabled', false)

    $('.help').removeClass('d-none')

  removeCard = (id) ->
    ids = $('#deck_card_ids').val().split(',')
    ids.splice(ids.indexOf(id.toString()), 1)
    $('#deck_card_ids').val(ids.join(','))

    $(".deck-card[data-card-id=#{id}]").remove()

    button = $(".deck-toggle[data-card-id=#{id}]")
    if button != undefined
      button.html('<i class="fa fa-plus"></i> Add')
      button.find('i').attr('class', 'fa fa-plus')
      button.attr('data-action', 'add')

    if ids.length < 5
      $('.deck-toggle[data-action=add]').prop('disabled', false)
      $('form.deck-submit input[type=submit]').prop('disabled', true)

    if ids.length == 0
      $('.help').addClass('d-none')

  updateIds = ->
    ids = $('.deck-card').map -> $(this).data('card-id')
    $('#deck_card_ids').val(ids.get().join(','))

  addDeckListeners = ->
    $('.card-large').click ->
      removeCard($(this).parent().data('card-id'))

    $('.card-large').mousedown ->
      $(this).tooltip('dispose')

  addSearchListeners = ->
    $('.deck-toggle').click ->
      id = $(this).data('card-id')

      if $(this).attr('data-action') == 'add'
        addCard(id)
        updateView('deck')
      else
        removeCard(id)

  addSearchListeners()
  addDeckListeners()

  $('.search-form').submit ->
    $(this).find('input[type=submit]').blur()
    $('.search-results').fadeOut(300, ->
      updateView('search')
    )
    false

  $('#deck_rule_id').change ->
    $('#deck_npc_id').val('') if $(this).val() != ''

  $('#deck_npc_id').change ->
    $('#deck_rule_id').val('') if $(this).val() != ''

  # Add drag-and-drop card ordering with sortable-rails
  $('.card-list-lg').sortable(
    onStart: ->
      $('.card-large').tooltip('disable')
    onEnd: ->
      $('.card-large').tooltip('enable')
      updateIds()
  )
