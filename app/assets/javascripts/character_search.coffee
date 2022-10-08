$(document).on 'turbolinks:load', ->
  filterServers = (data_center) ->
    $('#server option').show()

    if data_center.length > 0
      $("#server option:not(.dc-#{data_center.toLowerCase()})").hide()

  # Disable character selection on click to avoid multiple submissions
  characters = $('.character-select')
  if characters.length > 0
    characters.find('a').click ->
      characters.addClass('disabled')
      $(this).blur()

  $('.lodestone-search').click ->
    $(this).addClass('disabled')
    $(this).blur()
