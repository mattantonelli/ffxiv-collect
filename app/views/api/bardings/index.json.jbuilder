json.query @query
json.count @bardings.length
json.results do
  json.cache! [@bardings, I18n.locale] do
    json.partial! 'api/bardings/barding', collection: @bardings, as: :barding, owned: @owned
  end
end
