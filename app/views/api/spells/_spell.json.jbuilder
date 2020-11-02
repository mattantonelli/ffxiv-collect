json.(spell, :id, :name, :description, :tooltip, :order, :rank, :patch)
json.owned owned.fetch(spell.id.to_s, '0%')
json.icon image_url("spells/#{spell.id}.png", skip_pipeline: true)

json.type do
  json.(spell.type, :id, :name)
end

json.aspect do
  json.(spell.aspect, :id, :name)
end

json.partial! 'api/shared/sources', collectable: spell
