json.cache! [@card, I18n.locale] do
  json.partial! 'card', card: @card, owned: @owned
end
