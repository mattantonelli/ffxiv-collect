json.(record, :id, :name, :description, :rarity, :location, :patch, :linked_record_id)
json.owned @owned.fetch(record.id.to_s, '0%')
json.image image_url("records/large/#{record.id}.png", skip_pipeline: true)
json.icon image_url("records/small/#{record.id}.png", skip_pipeline: true)

json.partial! 'api/shared/sources', collectable: record
