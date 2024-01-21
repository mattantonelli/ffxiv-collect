json.(npc, :id, :resident_id, :name, :difficulty, :excluded, :patch)
json.link npc_url(npc)

json.location do
  json.name npc.location.name
  json.region npc.location.region
  json.x npc.x
  json.y npc.y
end

json.quest do
  if npc.quest
    json.id npc.quest_id
    json.name npc.quest.name
    json.link "https://www.garlandtools.org/db/#quest/#{npc.quest_id}"
  else
    json.merge! nil
  end
end

json.rules npc.rules.map(&:name)
json.rule_ids npc.rules.map(&:id)

sets = []
sets += %i(fixed_cards variable_cards) if local_assigns[:include_deck]
sets << :rewards if local_assigns[:include_rewards]

sets.each do |set|
  json.set! set do
    json.partial! '/api/triad/cards/card', collection: npc.send(set), as: :card, skip_sources: true
  end
end
