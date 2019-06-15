json.query @query
json.count @mounts.length
json.results do
  json.partial! 'mount', collection: @mounts, as: :mount, owned: @owned
end
