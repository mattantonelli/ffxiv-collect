json.query @query
json.count @minions.length
json.results do
  json.cache! @minions do
    json.partial! 'api/minions/minion', collection: @minions, as: :minion, owned: @owned
  end
end
