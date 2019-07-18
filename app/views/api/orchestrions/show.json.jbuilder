json.cache! [@orchestrion, I18n.locale] do
  json.partial! 'api/orchestrions/orchestrion', orchestrion: @orchestrion, owned: @owned
end
