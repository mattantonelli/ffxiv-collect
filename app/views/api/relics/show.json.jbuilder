json.cache! [@relic, I18n.locale] do
  json.partial! 'api/relics/relic', relic: @relic, owned: @owned
end
