class Redis
  def self.current
    # TODO: Decide on one of these
    # Redis::Namespace.new(:collect, redis: Redis.new)
    @current ||= Redis::Namespace.new(:collect, redis: Redis.new)
  end

  def self.unlock_jobs!
    ActiveJob::Uniqueness.unlock!
  end
end
