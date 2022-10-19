json.query @query
json.count @records.length
json.results do
  json.cache! [@records, I18n.locale] do
    json.partial! 'api/survey_records/survey_record', collection: @records, as: :record
  end
end
