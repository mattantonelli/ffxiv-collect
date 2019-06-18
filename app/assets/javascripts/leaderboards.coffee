$(document).on 'turbolinks:load', ->
  return unless $('#data_center').length > 0

  updateServers = ->
    dc = $('#data_center').val().toLowerCase()
    if dc == ''
      $('#q_server_eq option').show()
    else
      $("#q_server_eq option:not(.#{dc})").hide()
      $("#q_server_eq option.#{dc}").show()
      $('#q_server_eq option:first').show()

  updateServers()

  $('#data_center').change ->
    updateServers()
    $('#q_server_eq').val('')
