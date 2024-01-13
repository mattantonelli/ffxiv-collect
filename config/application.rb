require_relative 'boot'

require "rails"
require "active_job/railtie"
require "active_model/railtie"
require "active_record/railtie"
require "action_controller/railtie"
require "action_view/railtie"
require "sprockets/railtie"

# ActionMailer is required for Devise as per https://github.com/heartcombo/devise/issues/5140
require "action_mailer/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module FfxivCollect
  class Application < Rails::Application
    # Initialize configuration defaults
    config.load_defaults 6.0

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.

    # Don't generate system test files.
    config.generators.system_tests = nil

    config.i18n.enforce_available_locales = false

    config.cache_store = :file_store, 'tmp/cache'

    config.session_store :cookie_store, key: '_ffxiv_collect_session', expire_after: 1.month, same_site: :lax

    config.active_job.queue_adapter = :sidekiq

    # Allows organization of models into subdirectories without requiring a clunky namespace
    # config.autoload_paths += Dir[Rails.root.join('app', 'controllers', 'triad')]
    config.autoload_paths += Dir[Rails.root.join('app', 'models', 'triad')]

    config.middleware.insert_before 0, Rack::Cors do
      allow do
        origins '*'
        resource '/api/*', headers: :any, methods: [:get, :options]
        resource '/discord/interactions', headers: :any, methods: [:post]
      end
    end
  end
end
