json.characters do
  json.partial! '/api/characters/character', collection: @characters, as: :character
end
