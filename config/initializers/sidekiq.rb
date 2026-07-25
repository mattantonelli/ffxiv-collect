Sidekiq.configure_server do |config|
  config.redis = {
    db: 1,
  }
end

Sidekiq.configure_client do |config|
  config.redis = {
    db: 1,
  }
end

Sidekiq.default_job_options = { retry: 0 }
