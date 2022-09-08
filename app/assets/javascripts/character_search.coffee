$(document).on 'turbolinks:load', ->
  # Disable character selection on click to avoid multiple submissions
  characters = $('.character-select')
  if characters.length > 0
    characters.find('a').click ->
      characters.addClass('disabled')
      $(this).blur()

  # Dynamically update server selection based on the selected data center
  if $('.character-search').length > 0
    $('#data_center').change ->
      data_center = $(this).val().toLowerCase()
      $('#server').val('')
      $('#server option').show()

      if data_center.length > 0
        $("#server option:not(.dc-#{data_center})").hide()
