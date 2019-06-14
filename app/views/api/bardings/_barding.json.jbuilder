json.(barding, :id, :name, :patch, :item_id)
json.icon image_url("bardings/#{barding.id}.png", skip_pipeline: true)
json.partial! 'api/shared/sources', collectable: barding
