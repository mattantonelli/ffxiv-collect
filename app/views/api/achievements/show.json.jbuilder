json.cache! [@achievement, I18n.locale] do
  json.partial! 'api/achievements/achievement', achievement: @achievement, owned: @owned
end
