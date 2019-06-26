json.query @query
json.count @titles.length
json.results do
  json.cache! @titles do
    json.partial! 'api/titles/title', collection: @titles, as: :title, owned: @owned
  end
end
