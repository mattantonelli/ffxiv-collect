json.cache! [@armoire, I18n.locale] do
  json.partial! 'api/armoires/armoire', armoire: @armoire, owned: @owned
end
