# Explicitly point to the rbenv bundle shim so the cronjob can find it
set :bundle_command, '~/.rbenv/shims/bundle exec'
set :output, 'log/whenever.log'

# Sync stale verified characters every 30m
every '0,30 * * * *' do
  rake 'characters:verified:sync'
end

# Cache collectable ownership
every '5 * * * *' do
  rake 'ownership:cache'
end

# Sync stale unverified characters daily
every '30 0 * * *' do
  rake 'characters:unverified:sync'
end
