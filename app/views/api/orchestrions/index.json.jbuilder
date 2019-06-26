json.query @query
json.count @orchestrions.length
json.results do
  json.cache! @orchestrions do
    json.partial! 'api/orchestrions/orchestrion', collection: @orchestrions, as: :orchestrion, owned: @owned
  end
end
