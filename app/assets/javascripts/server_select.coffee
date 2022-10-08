$(document).on 'turbolinks:load', ->
  if $('#server').length > 0
    # Dynamically update server selection based on the selected data center
    filterServers = (data_center) ->
      $('#server option').show()

      if data_center.length > 0
        $("#server option:not(.dc-#{data_center.toLowerCase()})").hide()

    # Filter servers on page load in case a DC is already selected
    filterServers($('#data_center').val())

    $('#data_center').change ->
      $('#server').val('')
      filterServers($(this).val())
