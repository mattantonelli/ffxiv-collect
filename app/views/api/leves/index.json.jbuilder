json.query @query
json.count @leves.length
json.results do
  json.cache! [@leves, I18n.locale] do
    json.partial! 'api/leves/leve', collection: @leves, as: :leve
  end
end
