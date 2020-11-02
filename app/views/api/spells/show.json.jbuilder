json.cache! [@spell, I18n.locale] do
  json.partial! 'api/spells/spell', spell: @spell, owned: @owned
end
