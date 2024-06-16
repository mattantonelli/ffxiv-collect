json.(card, :id, :name, :description, :stars, :patch, :sell_price, :order_group, :order, :deck_order)
json.number card.formatted_number
json.icon image_url("cards/small/#{card.id}.png", skip_pipeline: true)
json.image image_url("cards/large/#{card.id}.png", skip_pipeline: true)
json.image_red image_url("cards/red/#{card.id}.png", skip_pipeline: true)
json.image_blue image_url("cards/blue/#{card.id}.png", skip_pipeline: true)
json.link card_url(card)

json.stats do
  json.numeric do
    json.(card, :top, :right, :bottom, :left)
  end

  json.formatted do
    %i(top right bottom left).each do |side|
      json.set! side, card.stat(side)
    end
  end
end

json.type do
  json.id card.type.id
  json.name card.type.name
  json.image card.type.id > 0 ? image_url("cards/types/#{card.type.id}.png", skip_pipeline: true) : nil
end

json.owned @owned.fetch(card.id.to_s, '0%')

unless local_assigns[:skip_sources]
  json.partial! 'api/shared/sources', collectable: card
end
