class CreateCharacterArmoires < ActiveRecord::Migration[5.2]
  def change
    create_table :character_armoires do |t|
      t.integer :character_id
      t.integer :armoire_id

      t.timestamps
    end
    add_index :character_armoires, :character_id
    add_index :character_armoires, :armoire_id
    add_index :character_armoires, [:character_id, :armoire_id], unique: true
  end
end
