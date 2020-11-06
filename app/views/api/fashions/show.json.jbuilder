json.cache! [@fashion, I18n.locale] do
  json.partial! 'api/fashions/fashion', fashion: @fashion, owned: @owned
end
