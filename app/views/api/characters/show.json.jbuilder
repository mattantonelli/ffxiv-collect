json.cache! [@character, params[:ids].present?] do
  json.partial! 'api/characters/character', character: @character
end
