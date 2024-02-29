source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.1.0'

gem 'rails', '~> 6.1.7'
gem 'mysql2', '>= 0.4.4', '< 0.6.0'
gem 'sassc-rails'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.2'
gem 'turbolinks', '~> 5'
gem 'jbuilder', '~> 2.5'
gem 'bootsnap', '>= 1.4.2', require: false
gem 'rack-cors', '~> 2.0.1'
gem 'rack', '>= 2.2.6.3'
gem 'websocket-extensions', '>= 0.1.5'

gem 'devise'
gem 'omniauth-discord'
gem 'omniauth-rails_csrf_protection', '~> 1.0'

gem 'bootstrap', '~> 4.6.2'
gem 'jquery-rails'
gem 'font_awesome5_rails'
gem 'will_paginate'
gem 'will_paginate-bootstrap4'
gem 'clipboard-rails'
gem 'sortable-rails'
gem 'momentjs-rails'
gem 'js_cookie_rails'
gem 'rails_bootstrap_sortable'
gem 'i18n-js', '3.9.1'

gem 'lograge'
gem 'whenever'
gem 'ransack', '~> 3.2.1'
gem 'chunky_png'
gem 'sprite-factory'
gem 'redis-namespace'
gem 'traco'
gem 'rest-client'
gem 'paper_trail', '~> 11.1.0'
gem 'sidekiq', '~> 6.5.8'
gem 'sidekiq-failures', '~> 1.0.0'
gem 'activejob-uniqueness'
gem 'nokogiri', '>= 1.13.6'
gem 'friendly_id', '~> 5.4.0'

# Discord interactions
gem 'ed25519'
gem 'discordrb-webhooks', '3.3.0'

# Compatibility fix for Rails 6 / Ruby 3.1. Should be resolved in Rails 7.0.1
gem 'net-imap', require: false
gem 'net-pop', require: false
gem 'net-smtp', require: false

group :development, :test do
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'rack-mini-profiler'
  gem 'i18n_yaml_sorter'
end

group :development do
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'puma', '~> 5.0'
  gem 'annotate'

  gem 'capistrano', '3.16.0'
  gem 'capistrano-bundler'
  gem 'capistrano-rbenv'
  gem 'capistrano-rails'
  gem 'capistrano-sidekiq'
end
