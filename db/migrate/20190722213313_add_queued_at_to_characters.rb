class AddQueuedAtToCharacters < ActiveRecord::Migration[5.2]
  def change
    add_column :characters, :queued_at, :datetime, default: Time.at(0)
    change_column_null :characters, :last_parsed, true
  end
end
