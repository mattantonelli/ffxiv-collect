json.query @query
json.count @cards.length
json.results do
  json.cache! [@cards, I18n.locale] do
    json.partial! 'api/triad/cards/card', collection: @cards, as: :card
  end
end
