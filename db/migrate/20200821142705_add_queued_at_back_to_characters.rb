class AddQueuedAtBackToCharacters < ActiveRecord::Migration[5.2]
  def change
    add_column :characters, :queued_at, :datetime, default: Time.at(0)
  end
end
