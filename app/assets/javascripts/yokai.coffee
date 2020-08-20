$(document).on 'turbolinks:load', ->
  $('table.yokai > tbody > tr').click ->
    $(@).siblings().removeClass('active')
    $(@).toggleClass('active')
