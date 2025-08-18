json.(emote, :id, :name, :command, :order, :patch, :item_id)

json.tradeable emote.tradeable?
if @prices.present?
  json.market @prices[emote.item_id]
end

json.owned @owned.fetch(emote.id.to_s, '0%')
json.icon image_url("emotes/#{emote.id}.png", skip_pipeline: true)

json.category do
  json.(emote.category, :id, :name)
end

json.partial! 'api/shared/sources', collectable: emote
