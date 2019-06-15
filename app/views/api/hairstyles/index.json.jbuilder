json.query @query
json.count @hairstyles.length
json.results do
  json.partial! 'hairstyle', collection: @hairstyles, as: :hairstyle, owned: @owned
end
