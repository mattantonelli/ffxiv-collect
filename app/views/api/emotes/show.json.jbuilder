json.cache! @emote do
  json.partial! 'api/emotes/emote', emote: @emote, owned: @owned
end
