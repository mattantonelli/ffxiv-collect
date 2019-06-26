json.cache! @minion do
  json.partial! 'api/minions/minion', minion: @minion, owned: @owned
end
