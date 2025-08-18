json.(minion, :id, :name, :description, :enhanced_description, :tooltip, :patch, :item_id)

json.tradeable minion.tradeable?
if @prices.present?
  json.market @prices[minion.item_id]
end

json.behavior do
  json.(minion.behavior, :id, :name)
end

json.race do
  json.(minion.race, :id, :name)
end

json.image image_url("minions/large/#{minion.id}.png", skip_pipeline: true)
json.icon image_url("minions/small/#{minion.id}.png", skip_pipeline: true)

unless minion.variant?
  json.owned @owned.fetch(minion.id.to_s, '0%')
  json.partial! 'api/shared/sources', collectable: minion
end

if minion.variants?
  json.variants do
    json.partial! 'api/minions/minion', collection: minion.variants.include_related.ordered, as: :minion
  end
else
  json.verminion do
    json.(minion, :cost, :attack, :defense, :hp, :speed, :area_attack, :skill, :skill_description,
          :skill_angle, :skill_cost, :eye, :gate, :shield)
    json.skill_type do
      json.(minion.skill_type, :id, :name)
    end
  end
end
