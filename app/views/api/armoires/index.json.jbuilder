json.query @query
json.count @armoires.length
json.results do
  json.partial! 'armoire', collection: @armoires, as: :armoire, owned: @owned
end
