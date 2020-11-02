class CreateCharacterItems < ActiveRecord::Migration[5.2]
  def change
    create_table :character_items do |t|
      t.integer :character_id
      t.integer :item_id

      t.timestamps
    end
    add_index :character_items, :character_id
    add_index :character_items, :item_id
    add_index :character_items, [:character_id, :item_id], unique: true

    add_column :characters, :items_count, :integer, default: 0
    add_index :characters, :items_count
  end
end
