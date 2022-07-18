json.query @query
json.count @hairstyles.length
json.results do
  json.cache! [@hairstyles, I18n.locale] do
    json.partial! 'api/hairstyles/hairstyle', collection: @hairstyles, as: :hairstyle
  end
end
