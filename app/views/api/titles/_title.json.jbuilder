json.(title, :id, :name, :female_name, :order)
json.owned owned.fetch(title.achievement_id.to_s, '0%')
json.icon image_url("achievements/#{title.achievement_id}.png", skip_pipeline: true)

json.achievement do
  json.partial! 'api/achievements/achievement', achievement: title.achievement, owned: owned
end
