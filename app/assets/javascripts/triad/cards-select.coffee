$(document).on 'turbolinks:load', ->
  return unless $('.card-select').length > 0

  all_cards = ->
    $('.card-select')

  standard_cards = ->
    $('.card-select:not(.ex)')

  ex_cards = ->
    $('.card-select.ex')

  owned_cards = ->
    $('.card-select:not(.missing)')

  page = 1
  dirty = false
  page_size = 30
  standard_page_max = Math.ceil(standard_cards().length / page_size)
  ex_page_max       = Math.ceil(ex_cards().length / page_size)
  page_max = standard_page_max + ex_page_max

  navigate_to = (page) ->
    # Grab the standard or EX cards, depending on the page
    if page <= standard_page_max
      cards = standard_cards()
      slicePage = page
    else
      cards = ex_cards()
      slicePage = page - standard_page_max

    # Display only cards visible on the page
    all_cards().hide()
    cards.slice((slicePage - 1) * page_size, page * page_size).show()

    $('#page').text(I18n.t('triad.card_select.page', number: page))

  update_cards = ->
    $('#total').text(I18n.t('triad.card_select.total', owned: owned_cards().length, total: all_cards().length))
    ids = $.map owned_cards(), (card) -> $(card).data('id')
    $('#card-ids').val(ids.toString())
    dirty = true

  reset_page = ->
    page = 1
    navigate_to(page)

  navigate_to(page)

  $(document).off 'turbolinks:before-visit'
  $(document).on 'turbolinks:before-visit', ->
    if $('.card-select').length > 0 && dirty then return confirm(I18n.t('triad.card_select.not_saved'))

  window.onbeforeunload = ->
    if $('.card-select').length > 0 && dirty then return true

  $('#add-all').click ->
    all_cards().removeClass('missing')
    update_cards()
    reset_page()

  $('#remove-all').click ->
    owned_cards().addClass('missing')
    update_cards()
    reset_page()

  $('.card-select').click ->
    card = $(this)

    if card.hasClass('missing')
      card.removeClass('missing')
    else
      card.addClass('missing')

    update_cards()
    navigate_to(page)

  $('#nav-prev').click ->
    page = if page == 1 then page_max else page - 1
    navigate_to(page)

  $('#nav-next').click ->
    page = if page == page_max then 1 else page + 1
    navigate_to(page)

  $('#submit').click ->
    dirty = false
    $('form').submit()
