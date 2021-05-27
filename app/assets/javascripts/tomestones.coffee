$(document).on 'turbolinks:load', ->
  return unless $('.tomestones').length > 0

  costSum = (selector) ->
    sum = 0
    sum += parseInt($(cost).text()) for cost in $("#{selector} .cost")
    sum

  updateTomestonesProgress = ->
    # Update the collection progress bar based on visible collectables
    progress = $('.progress-bar').eq(1)
    current = costSum('.owned:not(.hidden)')
    max = costSum('tr.collectable:not(.hidden)')

    if max > 0
      completion = (current / max) * 100
      progress.attr('aria-valuenow', current)
      progress.attr('style', "width: #{completion}%")
      progress.find('b').text("#{current}/#{max} (#{parseInt(completion)}%)")

  updateTomestonesProgress()

  $('td input.own').change ->
    updateTomestonesProgress()
