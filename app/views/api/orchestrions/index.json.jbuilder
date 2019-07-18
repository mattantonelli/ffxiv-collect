json.query @query
json.count @orchestrions.length
json.results do
  json.cache! [@orchestrions, I18n.locale] do
    json.partial! 'api/orchestrions/orchestrion', collection: @orchestrions, as: :orchestrion, owned: @owned
  end
end
