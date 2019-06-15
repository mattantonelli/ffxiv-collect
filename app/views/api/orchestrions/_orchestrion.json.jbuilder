json.(orchestrion, :id, :name, :description, :patch, :item_id)
json.owned owned.fetch(orchestrion.id.to_s, '0%')
json.number orchestrion_number(orchestrion)
json.icon image_url("orchestrion.png", skip_pipeline: true)
