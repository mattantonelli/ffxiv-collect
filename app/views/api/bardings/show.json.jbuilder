json.cache! [@barding, I18n.locale] do
  json.partial! 'api/bardings/barding', barding: @barding, owned: @owned
end
