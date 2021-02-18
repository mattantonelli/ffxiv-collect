$(document).on 'turbolinks:load', ->
  return unless $('#verification').length > 0
  new Clipboard('.clipboard')
