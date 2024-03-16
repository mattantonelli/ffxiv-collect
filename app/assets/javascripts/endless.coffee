$(document).on 'turbolinks:load', ->
  return unless $('.endless-check').length > 0

  max_visible = $('tr.collectable:visible').length
  current = 0
  max = max_visible

  $('.endless-check input').change ->
    $(@).closest('tr').addClass('hidden')
    $('tr.collectable').eq(max_visible).removeClass('hidden')

    row = $(@).closest('tr')
    row.insertAfter($('tr.collectable:last'))
    $(@).prop('checked', false)

    current += 1
    max *= 2 if current == max
    completion = (current / max) * 100

    $('.progress-bar').attr('aria-valuenow', current)
    $('.progress-bar').attr('style', "width: #{completion}%")
    $('.progress-label').text("#{current}/#{max} (#{parseInt(completion)}%)")
