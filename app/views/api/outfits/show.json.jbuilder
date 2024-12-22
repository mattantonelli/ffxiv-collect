json.cache! [@outfit, I18n.locale] do
  json.partial! 'api/outfits/outfit', outfit: @outfit, owned: @owned
end
