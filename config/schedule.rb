# Explicitly point to the rbenv bundle shim so the cronjob can find it
set :bundle_command, '~/.rbenv/shims/bundle exec'
set :output, 'log/whenever.log'

# Sync stale verified characters hourly
every '0 * * * *' do
  rake 'characters:sync_verified'
end

# Sync stale unverified characters daily
every '30 0 * * *' do
  rake 'characters:sync_unverified'
end
