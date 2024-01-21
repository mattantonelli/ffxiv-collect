json.(pack, :id, :name, :cost)
json.link packs_url(anchor: pack.id)

unless local_assigns[:skip_cards]
  json.cards do
    json.partial! '/api/triad/cards/card',
      collection: pack.cards.sort_by { |card| [card.stars, card.name] },
      as: :card, skip_sources: true
  end
end
