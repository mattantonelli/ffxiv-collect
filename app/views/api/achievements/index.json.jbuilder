json.query @query
json.count @achievements.length
json.results do
  json.partial! 'achievement', collection: @achievements, as: :achievement
end
