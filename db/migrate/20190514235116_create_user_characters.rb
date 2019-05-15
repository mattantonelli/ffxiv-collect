class CreateUserCharacters < ActiveRecord::Migration[5.2]
  def change
    create_table :user_characters do |t|
      t.integer :user_id
      t.integer :character_id

      t.timestamps
    end
    add_index :user_characters, :user_id
    add_index :user_characters, :character_id
    add_index :user_characters, [:user_id, :character_id], unique: true
  end
end
