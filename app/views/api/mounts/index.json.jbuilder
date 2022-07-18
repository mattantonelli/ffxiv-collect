json.query @query
json.count @mounts.length
json.results do
  json.cache! [@mounts, I18n.locale] do
    json.partial! 'api/mounts/mount', collection: @mounts, as: :mount
  end
end
