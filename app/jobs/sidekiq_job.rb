class SidekiqJob
  include Sidekiq::Worker

  sidekiq_options(
    lock: :until_and_while_executing,
    on_conflict: :log,
  )
end
