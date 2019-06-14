json.query @query
json.count @orchestrions.length
json.results do
  json.partial! 'orchestrion', collection: @orchestrions, as: :orchestrion
end
