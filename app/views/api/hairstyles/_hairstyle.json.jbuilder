json.(hairstyle, :id, :name, :description, :patch, :item_id)
json.owned owned.fetch(hairstyle.id.to_s, '0%')
json.partial! 'api/shared/sources', collectable: hairstyle
