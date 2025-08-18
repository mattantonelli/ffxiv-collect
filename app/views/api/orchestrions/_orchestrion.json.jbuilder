json.(orchestrion, :id, :name, :description, :patch, :item_id)

json.tradeable orchestrion.tradeable?
if @prices.present?
  json.market @prices[orchestrion.item_id]
end

json.owned @owned.fetch(orchestrion.id.to_s, '0%')
json.number orchestrion_number(orchestrion)
json.icon image_url("orchestrion.png", skip_pipeline: true)

json.category do
  json.(orchestrion.category, :id, :name)
end

json.partial! 'api/shared/sources', collectable: orchestrion
