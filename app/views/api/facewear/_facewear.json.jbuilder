json.(facewear, :id, :name, :order, :patch, :item_id)

json.tradeable facewear.tradeable?
if @prices.present?
  json.market @prices[facewear.item_id]
end

json.owned @owned.fetch(facewear.id.to_s, '0%')
json.icon image_url("facewear/#{facewear.id}.png", skip_pipeline: true)

json.partial! 'api/shared/sources', collectable: facewear
