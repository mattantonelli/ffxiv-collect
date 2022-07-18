json.(hairstyle, :id, :name, :description, :patch, :item_id)

json.tradeable hairstyle.item_id.present?
if @prices.present?
  json.market @prices[hairstyle.item_id]
end

json.owned @owned.fetch(hairstyle.id.to_s, '0%')
json.icon image_url("hairstyles/samples/#{hairstyle.id}.png", skip_pipeline: true)
json.partial! 'api/shared/sources', collectable: hairstyle
