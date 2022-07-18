json.query @query
json.count @armoires.length
json.results do
  json.cache! [@armoires, I18n.locale] do
    json.partial! 'api/armoires/armoire', collection: @armoires, as: :armoire
  end
end
