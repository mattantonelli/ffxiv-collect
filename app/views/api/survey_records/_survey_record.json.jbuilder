json.(record, :id, :name, :description, :solution, :patch)
json.dungeon record.series.name
json.owned @owned.fetch(record.id.to_s, '0%')
json.image image_url("survey_records/large/#{record.id}.png", skip_pipeline: true)
json.icon image_url("survey_records/small/#{record.id}.png", skip_pipeline: true)
