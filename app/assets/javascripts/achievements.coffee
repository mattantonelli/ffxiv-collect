$(document).on 'turbolinks:load', ->
  return unless $('#achievementCategories').length > 0

  if id = $(location).attr('hash')
    anchor = id.replace('#', '#collapse-')
    $(anchor).collapse('show')

  $('#collapseToggle').click ->
    button = $('#collapseToggle')

    if button.data('expanded')
      $('#achievementCategories .collapse').collapse('hide')
      button.data('expanded', false)
      button.html('<i class="fa fa-expand"></i> Expand All')
    else
      $('#achievementCategories .collapse').collapse('show')
      button.data('expanded', true)
      button.html('<i class="fa fa-compress"></i> Collapse All')
