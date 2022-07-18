json.query @query
json.count @minions.length
json.results do
  json.cache! [@minions, I18n.locale] do
    json.partial! 'api/minions/minion', collection: @minions, as: :minion
  end
end
