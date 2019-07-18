json.cache! [@title, I18n.locale] do
  json.partial! 'api/titles/title', title: @title, owned: @owned
end
