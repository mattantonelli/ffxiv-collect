json.(barding, :id, :name, :order, :patch, :item_id)
json.tradeable barding.item_id.present?
json.owned owned.fetch(barding.id.to_s, '0%')
json.icon image_url("bardings/#{barding.id}.png", skip_pipeline: true)
json.partial! 'api/shared/sources', collectable: barding
