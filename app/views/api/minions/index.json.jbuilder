json.query @query
json.count @minions.length
json.results do
  json.partial! 'minion', collection: @minions, as: :minion, owned: @owned
end
