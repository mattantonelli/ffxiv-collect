json.query @query
json.count @mounts.length
json.results do
  json.cache! @mounts do
    json.partial! 'api/mounts/mount', collection: @mounts, as: :mount, owned: @owned
  end
end
