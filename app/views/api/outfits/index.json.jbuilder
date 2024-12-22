json.query @query
json.count @outfits.length
json.results do
  json.cache! [@outfits, I18n.locale] do
    json.partial! 'api/outfits/outfit', collection: @outfits, as: :outfit
  end
end
