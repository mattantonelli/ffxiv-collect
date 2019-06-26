json.query @query
json.count @achievements.length
json.results do
  json.cache! @achievements do
    json.partial! 'api/achievements/achievement', collection: @achievements, as: :achievement, owned: @owned
  end
end
