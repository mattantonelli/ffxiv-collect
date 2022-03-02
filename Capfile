require 'capistrano/setup'
require 'capistrano/deploy'
require 'capistrano/rbenv'
require 'capistrano/bundler'
require 'capistrano/rails'
require 'whenever/capistrano'

require 'capistrano/sidekiq'
install_plugin Capistrano::Sidekiq
install_plugin Capistrano::Sidekiq::Systemd

require 'capistrano/scm/git'
install_plugin Capistrano::SCM::Git

Dir.glob('lib/capistrano/tasks/*.rake').each { |r| import r }
