# Explicitly point to the rbenv bundle shim so the cronjob can find it
set :bundle_command, '~/.rbenv/shims/bundle exec'
set :output, 'log/whenever.log'

every '0 * * * *' do
  rake 'characters:sync'
end
