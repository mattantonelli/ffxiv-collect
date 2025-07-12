# Explicitly point to the rbenv bundle shim so the cronjob can find it
set :bundle_command, '~/.rbenv/shims/bundle exec'
set :output, 'log/whenever.log'

# Cache leaderboard rankings for character profiles and the API
every '0 0,6,12,18 * * *' do
  rake 'cache:rankings:server'
end

every '5 0,6,12,18 * * *' do
  rake 'cache:rankings:data_center'
end

every '10 0,6,12,18 * * *' do
  rake 'cache:rankings:global'
end

# Cache item prices and FAQ stats
every '0 1 * * *' do
  rake 'cache:prices'
  rake 'cache:stats'
end

# Cache P2W data
every '10 1 * * *' do
  rake 'cache:p2w'
end

# Cache collectable ownership
every '10 3 * * *' do
  rake 'cache:ownership'
end
