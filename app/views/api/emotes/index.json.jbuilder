json.query @query
json.count @emotes.length
json.results do
  json.cache! @emotes do
    json.partial! 'api/emotes/emote', collection: @emotes, as: :emote, owned: @owned
  end
end
