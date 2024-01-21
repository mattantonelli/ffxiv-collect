json.query @query
json.count @packs.length
json.results do
  json.cache! [@packs, I18n.locale] do
    json.partial! 'api/triad/packs/pack', collection: @packs, as: :pack
  end
end
