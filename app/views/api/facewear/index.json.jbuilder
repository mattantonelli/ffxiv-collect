json.query @query
json.count @facewears.length
json.results do
  json.cache! [@facewears, I18n.locale] do
    json.partial! 'api/facewear/facewear', collection: @facewears, as: :facewear
  end
end
