$(document).on 'turbolinks:load', ->
  return unless $('.collapse').length > 0

  if id = $(location).attr('hash')
    anchor = id.replace('#', '#collapse-')
    $(anchor).collapse('show')

  $('#collapseToggle').click ->
    button = $('#collapseToggle')

    if button.data('expanded')
      $('main .collapse').collapse('hide')
      button.data('expanded', false)
      button.html('<i class="fa fa-expand"></i> '+ I18n.t("general.expand_all"))
    else
      $('main .collapse').collapse('show')
      button.data('expanded', true)
      button.html('<i class="fa fa-compress"></i> '+ I18n.t("general.collapse_all"))
