json.(mount, :id, :name, :description, :enhanced_description, :tooltip, :movement,
      :seats, :order, :order_group, :patch, :item_id)

json.tradeable mount.item_id.present?
if @prices.present?
  json.market @prices[mount.item_id]
end

json.owned @owned.fetch(mount.id.to_s, '0%')
json.image image_url("mounts/large/#{mount.id}.png", skip_pipeline: true)
json.icon image_url("mounts/small/#{mount.id}.png", skip_pipeline: true)

if mount.bgm_sample.present?
  json.bgm asset_url("/music/#{mount.bgm_sample}", skip_pipeline: true)
else
  json.bgm nil
end

json.partial! 'api/shared/sources', collectable: mount
