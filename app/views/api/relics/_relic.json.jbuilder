json.(relic, :id, :name, :order, :achievement_id)
json.icon image_url("relics/#{relic.type.category}/#{relic.id}.png", skip_pipeline: true)
json.owned @owned.fetch(relic.id.to_s, '0%')

json.type do
  json.(relic.type, :name, :category, :jobs, :order, :expansion)
end
