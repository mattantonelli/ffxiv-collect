$(document).on 'turbolinks:load', ->
  $('.tooltip').remove()
  $('[data-toggle=tooltip]').tooltip()
