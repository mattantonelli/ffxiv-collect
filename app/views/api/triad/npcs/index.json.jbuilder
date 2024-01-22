json.query @query
json.count @npcs.length
json.results do
  json.cache! [@npcs, @include_deck, I18n.locale] do
    json.partial! 'api/triad/npcs/npc', collection: @npcs, as: :npc,
      include_deck: @include_deck, include_rewards: true
  end
end
