json.query @query
json.count @achievements.length
json.results do
  json.cache! [@achievements, I18n.locale] do
    json.partial! 'api/achievements/achievement', collection: @achievements, as: :achievement
  end
end
