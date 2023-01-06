module Syncable
  extend ActiveSupport::Concern
  include Queueable

  def expire!
    update!(queued_at: Time.at(0))
  end

  def recently_queued?
    queued_at > Time.now - 5.seconds
  end

  def syncable?
    !recently_queued? && !in_queue? && (!up_to_date? || queued_at < Time.now - 6.hours)
  end

  def up_to_date?
    members.none?(&:stale?)
  end
end
