json.query @query
json.count @armoires.length
json.results do
  json.cache! @armoires do
    json.partial! 'api/armoires/armoire', collection: @armoires, as: :armoire, owned: @owned
  end
end
