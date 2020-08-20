class RenameQueuedAtToRefreshedAt < ActiveRecord::Migration[5.2]
  def change
    rename_column :characters, :queued_at, :refreshed_at
  end
end
