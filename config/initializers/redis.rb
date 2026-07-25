class Redis
  def self.current
    @current ||= Redis.new(db: 1)
  end

  def self.unlock_jobs!
    ActiveJob::Uniqueness.unlock!
  end
end
