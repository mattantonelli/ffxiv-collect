module Syncable
  extend ActiveSupport::Concern

  def expire!
    update!(queued_at: Time.at(0))
  end

  def up_to_date?
    members.none?(&:stale?)
  end

  def syncable?
    !syncing? && (!up_to_date? || queued_at < Time.now - 6.hours)
  end

  # TODO: add fields to character groups and free companies. update them when jobs are queued/finished. set all to false on Redis.clear_queues!
  def syncing?
    false
  end
end
