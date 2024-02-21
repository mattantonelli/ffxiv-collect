json.cache! [@character, params[:ids].present?, params[:times].present?] do
  json.partial! 'api/characters/character', character: @character
end
