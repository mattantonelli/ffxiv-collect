json.(fashion, :id, :name, :description, :order, :patch, :item_id)

json.tradeable fashion.tradeable?
if @prices.present?
  json.market @prices[fashion.item_id]
end

json.owned @owned.fetch(fashion.id.to_s, '0%')
json.image image_url("fashions/large/#{fashion.id}.png", skip_pipeline: true)
json.icon image_url("fashions/small/#{fashion.id}.png", skip_pipeline: true)

json.partial! 'api/shared/sources', collectable: fashion
