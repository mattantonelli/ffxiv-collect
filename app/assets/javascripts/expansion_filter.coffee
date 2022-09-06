$(document).on 'turbolinks:load', ->
  return unless $('.expansion-filter').length > 0

  # When an expansion checkbox is changed
  $('.expansion-filter').change ->
    # Toggle the visibility of elements matching the expansion
    id = $(this).attr('id')
    $("th.#{id}, td.#{id}").toggle(this.checked)

    # Save checkbox preferences to a cookie for subsequent page visits
    hidden = []

    $('.expansion-filter:not(:checked)').each ->
      hidden.push($(this).val())

    Cookies.set('hide_expansions', hidden.join(','))

  # Set the state of the checkboxes based on saved Cookie preferences
  if hidden = Cookies.get('hide_expansions')
    for expansion in hidden.split(',')
      $("input#expansion-#{expansion}").click()
