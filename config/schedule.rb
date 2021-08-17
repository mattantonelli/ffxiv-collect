# Explicitly point to the rbenv bundle shim so the cronjob can find it
set :bundle_command, '~/.rbenv/shims/bundle exec'
set :output, 'log/whenever.log'

# Cache collectable ownership
every '10 3 * * *' do
  rake 'ownership:cache'
end

# Cache item prices
every '0 0 * * *' do
  rake 'prices:cache'
end

# Cache P2W data
every '5 0 * * *' do
  rake 'p2w:cache'
end
