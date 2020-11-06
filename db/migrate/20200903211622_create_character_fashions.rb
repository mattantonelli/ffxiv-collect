class CreateCharacterFashions < ActiveRecord::Migration[5.2]
  def change
    create_table :character_fashions do |t|
      t.integer :character_id
      t.integer :fashion_id

      t.timestamps
    end

    add_index :character_fashions, :character_id
    add_index :character_fashions, :fashion_id
    add_index :character_fashions, [:character_id, :fashion_id], unique: true

    add_column :characters, :fashions_count, :integer, default: 0
    add_index :characters, :fashions_count
  end
end
