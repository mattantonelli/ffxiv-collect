json.(achievement, :id, :name, :description, :points, :order, :patch)
json.owned owned.fetch(achievement.id.to_s, '0%')
json.icon image_url("achievements/#{achievement.icon_id}.png", skip_pipeline: true)

category = achievement.category

json.category do
  json.(category, :id, :name)
end

json.type do
  json.(category.type, :id, :name)
end

json.reward do
  if achievement.title.present?
    json.type 'Title'
    json.name achievement.title
  elsif achievement.item_id.present?
    json.type 'Item'
    json.name achievement.item_name
  end
end
