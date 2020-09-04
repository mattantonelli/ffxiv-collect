json.query @query
json.count @fashions.length
json.results do
  json.cache! [@fashions, I18n.locale] do
    json.partial! 'api/fashions/fashion', collection: @fashions, as: :fashion, owned: @owned
  end
end
