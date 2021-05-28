json.cache! [@record, I18n.locale] do
  json.partial! 'api/records/record', record: @record, owned: @owned
end
