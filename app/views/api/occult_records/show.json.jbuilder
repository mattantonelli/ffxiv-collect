json.cache! [@occult_record, I18n.locale] do
  json.partial! 'api/occult_records/occult_record', occult_record: @occult_record, owned: @owned
end
