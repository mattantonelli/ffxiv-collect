json.cache! [@survey_record, I18n.locale] do
  json.partial! 'api/survey_records/survey_record', survey_record: @survey_record, owned: @owned
end
