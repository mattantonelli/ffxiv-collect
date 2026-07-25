class Redis
  def self.current
    @current ||= Redis.new(db: 1)
  end

  def self.clear_queues!
    Sidekiq::Queue.all.each(&:clear)
  end

  def self.unlock_jobs!
    SidekiqUniqueJobs::Orphans::Reaper.call
  end
end
