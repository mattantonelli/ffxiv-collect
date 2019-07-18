json.cache! [@mount, I18n.locale] do
  json.partial! 'api/mounts/mount', mount: @mount, owned: @owned
end
