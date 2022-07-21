json.query @query
json.count @rewards.length
json.results do
  json.cache! [@rewards, I18n.locale] do
    json.collectables @collectables do |reward|
      json.(reward.collectable, :id, :name)
      json.type reward.collectable_type
      json.partial! 'api/shared/sources', collectable: reward.collectable
      json.tradeable reward.collectable.item_id.present?
      json.(reward, :cost)
    end

    json.items @items do |reward|
      json.(reward.collectable, :id, :name, :tradeable)
      json.type reward.collectable_type
      json.(reward, :cost)
    end
  end
end
