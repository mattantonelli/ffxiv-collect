$(document).on 'turbolinks:load', ->
  return unless $('.isearch').length > 0

  clipboard = new Clipboard('.isearch')
  clipboard.on 'success', (e) ->
    $(e.trigger).tooltip('show').attr('data-original-title', 'Copied /isearch command').tooltip('show')
    setTimeout ->
      $(e.trigger).tooltip('dispose')
    , 2000
