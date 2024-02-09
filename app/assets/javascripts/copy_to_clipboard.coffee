$(document).on 'turbolinks:load', ->
  if $('.isearch').length > 0
    clipboard = new Clipboard('.isearch')
    clipboard.on 'success', (e) ->
      $(e.trigger).tooltip('show').attr('data-original-title', I18n.t('copy.isearch')).tooltip('show')
      setTimeout ->
        $(e.trigger).tooltip('dispose')
      , 2000

  if $('.copy-name').length > 0
    clipboard = new Clipboard('.copy-name')
    clipboard.on 'success', (e) ->
      $(e.trigger).tooltip('show').attr('data-original-title', I18n.t('copy.name')).tooltip('show')
      setTimeout ->
        $(e.trigger).tooltip('dispose')
      , 2000
