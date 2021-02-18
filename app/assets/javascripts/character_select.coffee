$(document).on 'turbolinks:load', ->
  characters = $('.character-select')
  return unless characters.length > 0

  characters.find('a').click ->
    characters.addClass('disabled')
