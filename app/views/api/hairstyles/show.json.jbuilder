json.cache! [@hairstyle, I18n.locale] do
  json.partial! 'api/hairstyles/hairstyle', hairstyle: @hairstyle, owned: @owned
end
