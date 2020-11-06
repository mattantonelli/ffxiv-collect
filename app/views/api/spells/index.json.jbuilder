json.query @query
json.count @spells.length
json.results do
  json.cache! [@spells, I18n.locale] do
    json.partial! 'api/spells/spell', collection: @spells, as: :spell, owned: @owned
  end
end
