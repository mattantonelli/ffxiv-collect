# Explicitly point to the rbenv bundle shim so the cronjob can find it
set :bundle_command, '~/.rbenv/shims/bundle exec'
set :output, 'log/whenever.log'

# Cache leaderboard rankings for character profiles and the API
every '0 0,6,12,18 * * *' do
  rake 'rankings:cache'
end

# Cache item prices and FAQ stats
every '0 1 * * *' do
  rake 'prices:cache'
  rake 'stats:cache'
end

# Cache P2W data
every '10 1 * * *' do
  rake 'p2w:cache'
end

# Cache collectable ownership
every '10 3 * * *' do
  rake 'ownership:cache'
end
