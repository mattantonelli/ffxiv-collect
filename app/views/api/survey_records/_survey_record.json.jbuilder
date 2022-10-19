json.(survey_record, :id, :name, :description, :solution, :patch)
json.dungeon survey_record.series.name
json.owned @owned.fetch(survey_record.id.to_s, '0%')
json.image image_url("survey_records/large/#{survey_record.id}.png", skip_pipeline: true)
json.icon image_url("survey_records/small/#{survey_record.id}.png", skip_pipeline: true)
