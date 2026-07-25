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

  class_methods do
    # Resets the syncing status for all records - useful if sync jobs need to be aborted
    def reset_syncing!
      update_all(syncing: false)
    end
  end
end
