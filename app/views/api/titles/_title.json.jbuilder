json.(title, :id, :name, :female_name, :order)
json.owned owned.fetch(title.achievement_id.to_s, '0%')
json.icon image_url("achievements/#{title.achievement_id}.png", skip_pipeline: true)

unless local_assigns[:skip_achievement]
  json.achievement do
    json.partial! 'api/achievements/achievement', achievement: title.achievement, owned: owned, skip_reward: true
  end
end
