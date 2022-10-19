json.query @query
json.count @survey_records.length
json.results do
  json.cache! [@survey_records, I18n.locale] do
    json.partial! 'api/survey_records/survey_record', collection: @survey_records, as: :survey_record
  end
end
