json.cache! @barding do
  json.partial! 'api/bardings/barding', barding: @barding, owned: @owned
end
