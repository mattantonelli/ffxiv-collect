class Redis
  def self.current
    @current ||= Redis::Namespace.new(:collect, redis: Redis.new)
  end

  def self.unlock_jobs!
    ActiveJob::Uniqueness.unlock!
  end
end
