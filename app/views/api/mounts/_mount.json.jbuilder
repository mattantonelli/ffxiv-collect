json.(mount, :id, :name, :description, :enhanced_description, :tooltip, :flying, :movement,
      :seats, :order, :order_group, :patch, :item_id)
json.owned owned.fetch(mount.id.to_s, '0%')
json.image image_url("mounts/large/#{mount.id}.png", skip_pipeline: true)
json.icon image_url("mounts/small/#{mount.id}.png", skip_pipeline: true)

json.partial! 'api/shared/sources', collectable: mount
