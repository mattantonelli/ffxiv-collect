json.query @query
json.count @relics.length
json.results do
  json.cache! [@relics, I18n.locale] do
    json.partial! 'api/relics/relic', collection: @relics, as: :relic, owned: @owned
  end
end
