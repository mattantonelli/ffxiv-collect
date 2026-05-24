$ ->
  return unless $('#verification').length or $('#api-token').length
  new Clipboard('.clipboard')
