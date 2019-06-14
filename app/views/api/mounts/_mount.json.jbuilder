json.(mount, :id, :name, :description, :enhanced_description, :tooltip, :flying, :movement,
      :seats, :order, :patch, :item_id)

json.partial! 'api/shared/sources', collectable: mount

json.image image_url("mounts/large/#{mount.id}.png", skip_pipeline: true)
json.icon image_url("mounts/small/#{mount.id}.png", skip_pipeline: true)
