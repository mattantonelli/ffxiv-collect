json.query @query
json.count @decks.length
json.results do
  json.cache! [@decks, I18n.locale] do
    json.partial! 'api/triad/decks/deck', collection: @decks, as: :deck
  end
end
