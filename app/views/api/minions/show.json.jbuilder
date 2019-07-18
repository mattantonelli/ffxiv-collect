json.cache! [@minion, I18n.locale] do
  json.partial! 'api/minions/minion', minion: @minion, owned: @owned
end
