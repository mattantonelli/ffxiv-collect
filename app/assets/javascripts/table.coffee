$(document).on 'turbolinks:load', ->
  return unless $('#toggle-owned').length > 0

  restripe = ->
    $('tbody tr:visible').each (index) ->
      $(this).css('background-color', if index % 2 == 0 then 'rgba(0, 0, 0, 0.1)' else 'rgba(0, 0, 0, 0.2)')

  if localStorage.getItem('display-owned') == 'false'
    $('tr.owned').hide()
    $('#toggle-owned').prop('checked', true)
    restripe()

  $('#toggle-owned').change ->
    $('.owned').toggle()

    if !this.checked
      localStorage.setItem('display-owned', 'true')
    else
      localStorage.setItem('display-owned', 'false')

    restripe()
