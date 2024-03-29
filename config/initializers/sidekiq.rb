Sidekiq.configure_server do |config|
  config.redis = { namespace: 'collect:sidekiq' }
end

Sidekiq.configure_client do |config|
  config.redis = { namespace: 'collect:sidekiq' }
end

Sidekiq.default_job_options = { retry: 0 }
