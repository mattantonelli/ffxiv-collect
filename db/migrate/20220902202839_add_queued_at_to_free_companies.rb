class AddQueuedAtToFreeCompanies < ActiveRecord::Migration[6.1]
  def change
    add_column :free_companies, :queued_at, :datetime, default: Time.at(0)
  end
end
