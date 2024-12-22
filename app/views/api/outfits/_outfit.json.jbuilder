json.(outfit, :id, :name, :patch, :gender, :armoireable, :item_id)

json.tradeable outfit.item_id.present?
json.owned @owned.fetch(outfit.id.to_s, '0%')
json.icon image_url("outfits/#{outfit.id}.png", skip_pipeline: true)

json.items outfit.items do |item|
  json.(item, :id, :name)
end

json.partial! 'api/shared/sources', collectable: outfit
