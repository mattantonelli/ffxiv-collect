class CreateCharacterBardings < ActiveRecord::Migration[5.2]
  def change
    create_table :character_bardings do |t|
      t.integer :character_id
      t.integer :barding_id

      t.timestamps
    end
    add_index :character_bardings, :character_id
    add_index :character_bardings, :barding_id
    add_index :character_bardings, [:character_id, :barding_id], unique: true
  end
end
