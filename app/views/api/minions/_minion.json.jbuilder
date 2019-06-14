json.(minion, :id, :name, :description, :enhanced_description, :tooltip, :patch, :item_id)

json.behavior do
  json.(minion.behavior, :id, :name)
end

json.race do
  json.(minion.race, :id, :name)
end

json.image image_url("minions/large/#{minion.id}.png", skip_pipeline: true)
json.icon image_url("minions/small/#{minion.id}.png", skip_pipeline: true)

unless minion.variant?
  json.partial! 'api/shared/sources', collectable: minion
end

variants = minion.variants
if variants.present?
  json.variants do
    json.partial! 'minion', collection: variants, as: :minion
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
