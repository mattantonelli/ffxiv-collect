class CreateCharacterMinions < ActiveRecord::Migration[5.2]
  def change
    create_table :character_minions do |t|
      t.integer :character_id
      t.integer :minion_id

      t.timestamps
    end
    add_index :character_minions, :character_id
    add_index :character_minions, :minion_id
    add_index :character_minions, [:character_id, :minion_id], unique: true
  end
end
