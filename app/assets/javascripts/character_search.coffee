$(document).on 'turbolinks:load', ->
  filterServers = (data_center) ->
    $('#server option').show()

    if data_center.length > 0
      $("#server option:not(.dc-#{data_center.toLowerCase()})").hide()

  characters = $('.character-select')

  # Disable character selection on click to avoid multiple submissions
  if characters.length > 0
    characters.find('a').click ->
      characters.addClass('disabled')
      $(this).blur()

  $('.lodestone-search').click ->
    $(this).addClass('disabled')
    $(this).blur()

  # Reset disabled buttons on page load in case of back navigation
  characters.removeClass('disabled')
