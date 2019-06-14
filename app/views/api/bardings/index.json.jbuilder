json.query @query
json.count @bardings.length
json.results do
  json.partial! 'barding', collection: @bardings, as: :barding
end
