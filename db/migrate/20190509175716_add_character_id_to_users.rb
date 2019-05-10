class AddCharacterIdToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :character_id, :integer
    add_index :users, :character_id
  end
end
