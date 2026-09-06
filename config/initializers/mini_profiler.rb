if Rails.env.development?
  Rack::MiniProfiler.config.skip_paths << /.*\/tooltip/
end
