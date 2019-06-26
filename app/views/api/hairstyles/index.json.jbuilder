json.query @query
json.count @hairstyles.length
json.results do
  json.cache! @hairstyles do
    json.partial! 'api/hairstyles/hairstyle', collection: @hairstyles, as: :hairstyle, owned: @owned
  end
end
