json.query @query
json.count @titles.length
json.results do
  json.partial! 'title', collection: @titles, as: :title, owned: @owned
end
