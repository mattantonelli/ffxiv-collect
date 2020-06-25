json.cache! [@character, params[:ids]] do
  json.partial! 'api/characters/character', character: @character
end
