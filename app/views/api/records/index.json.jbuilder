json.query @query
json.count @records.length
json.results do
  json.cache! [@records, I18n.locale] do
    json.partial! 'api/records/record', collection: @records, as: :record, owned: @owned
  end
end
