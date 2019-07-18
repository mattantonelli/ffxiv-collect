json.cache! [@emote, I18n.locale] do
  json.partial! 'api/emotes/emote', emote: @emote, owned: @owned
end
