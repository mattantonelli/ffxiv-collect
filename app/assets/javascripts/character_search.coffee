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

  # Dynamically update server selection based on the selected data center
  if $('.character-search').length > 0
    # Filter servers on page load in case a DC is already selected
    filterServers($('#data_center').val())

    $('#data_center').change ->
      $('#server').val('')
      filterServers($(this).val())

  $('.lodestone-search').click ->
    $(this).addClass('disabled')
    $(this).blur()
