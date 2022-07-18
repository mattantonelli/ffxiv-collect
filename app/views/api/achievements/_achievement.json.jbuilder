json.(achievement, :id, :name, :description, :points, :order, :patch)
json.owned @owned.fetch(achievement.id.to_s, '0%')
json.icon image_url("achievements/#{achievement.icon_id}.png", skip_pipeline: true)

category = achievement.category

json.category do
  json.(category, :id, :name)
end

json.type do
  json.(category.type, :id, :name)
end

unless local_assigns[:skip_reward]
  json.reward do
    if achievement.title.present?
      json.type 'Title'
      json.title do
        json.partial! 'api/titles/title', title: achievement.title, owned: @owned, skip_achievement: true
      end
    elsif achievement.item_id.present?
      json.type 'Item'
      json.name achievement.item.name
    end
  end
end
