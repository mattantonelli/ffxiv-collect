json.(emote, :id, :name, :command, :patch, :item_id)
json.owned owned.fetch(emote.id.to_s, '0%')
json.icon image_url("emotes/#{emote.id}.png", skip_pipeline: true)

json.category do
  json.(emote.category, :id, :name)
end

json.partial! 'api/shared/sources', collectable: emote
