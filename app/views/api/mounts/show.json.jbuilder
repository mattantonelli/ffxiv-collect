json.cache! @mount do
  json.partial! 'api/mounts/mount', mount: @mount, owned: @owned
end
