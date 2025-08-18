json.query @query
json.count @rewards.length
json.results do
  json.collectables @collectables do |reward|
    json.(reward.collectable, :id, :name)
    json.type reward.collectable_type
    json.partial! 'api/shared/sources', collectable: reward.collectable
    json.tradeable reward.collectable.tradeable?
    json.(reward, :tomestone, :cost)
  end

  json.items @items do |reward|
    json.(reward.collectable, :id, :name, :tradeable)
    json.type reward.collectable_type
    json.(reward, :tomestone, :cost)
  end
end
