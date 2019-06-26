json.query @query
json.count @bardings.length
json.results do
  json.cache! @bardings do
    json.partial! 'api/bardings/barding', collection: @bardings, as: :barding, owned: @owned
  end
end
