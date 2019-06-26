json.cache! @orchestrion do
  json.partial! 'api/orchestrions/orchestrion', orchestrion: @orchestrion, owned: @owned
end
