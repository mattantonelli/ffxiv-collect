# Explicitly point to the rbenv bundle shim so the cronjob can find it
set :bundle_command, '~/.rbenv/shims/bundle exec'
set :output, 'log/whenever.log'

# Cache collectable ownership
every '5 * * * *' do
  rake 'ownership:cache'
end
