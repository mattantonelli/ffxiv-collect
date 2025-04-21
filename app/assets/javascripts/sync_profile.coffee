$(document).on 'turbolinks:load', ->
  return unless $('.sync-profile').length > 0

  # Disable refresh on click to avoid multiple submissions
  $('.sync-profile').click ->
    $(this).addClass('disabled')
    $(this).blur()
