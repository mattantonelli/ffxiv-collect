json.cache! [@facewear, I18n.locale] do
  json.partial! 'api/facewear/facewear', facewear: @facewear, owned: @owned
end
