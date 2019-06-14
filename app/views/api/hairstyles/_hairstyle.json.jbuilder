json.(hairstyle, :id, :name, :description, :patch, :item_id)
json.partial! 'api/shared/sources', collectable: hairstyle
