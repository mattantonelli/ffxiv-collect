json.cache! [@record, I18n.locale] do
  json.partial! 'api/survey_records/survey_record', record: @record, owned: @owned
end
