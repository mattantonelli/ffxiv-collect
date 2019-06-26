json.cache! @achievement do
  json.partial! 'api/achievements/achievement', achievement: @achievement, owned: @owned
end
