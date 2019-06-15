json.(armoire, :id, :name, :order, :patch)
json.owned owned.fetch(armoire.id.to_s, '0%')
json.icon image_url("armoire/#{armoire.id}.png", skip_pipeline: true)

json.category do
  json.(armoire.category, :id, :name)
end

json.partial! 'api/shared/sources', collectable: armoire
