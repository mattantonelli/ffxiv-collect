json.query @query
json.count @occult_records.length
json.results do
  json.cache! [@occult_records, I18n.locale] do
    json.partial! 'api/occult_records/occult_record', collection: @occult_records, as: :occult_record
  end
end
