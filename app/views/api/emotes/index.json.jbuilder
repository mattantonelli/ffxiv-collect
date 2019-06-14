json.query @query
json.count @emotes.length
json.results do
  json.partial! 'emote', collection: @emotes, as: :emote
end
