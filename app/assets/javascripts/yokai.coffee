$(document).on 'turbolinks:load', ->
  $('table.yokai > tbody > tr').click ->
    $(@).siblings().removeClass('active')
    $(@).addClass('active')
