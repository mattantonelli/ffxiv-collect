$(document).on 'turbolinks:load', ->
  $('.tooltip').remove()
  $('[data-toggle=tooltip]').tooltip()

  # Ignore blank fields on search form submission
  $('.search-form').submit ->
    hasData = false
    $(this).find('.form-control').filter ->
      if @value == ''
        $(@).prop('disabled', true)
      else
        hasData = true

    # Reload the page without params if all fields are blank
    if !hasData
      window.location = window.location.pathname
      return false
