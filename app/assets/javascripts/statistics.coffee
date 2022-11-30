$(document).on 'turbolinks:load', ->
  $('form#stat-limit select').change ->
    $('form#stat-limit').submit()
