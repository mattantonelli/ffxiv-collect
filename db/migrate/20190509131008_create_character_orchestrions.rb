class CreateCharacterOrchestrions < ActiveRecord::Migration[5.2]
  def change
    create_table :character_orchestrions do |t|
      t.integer :character_id
      t.integer :orchestrion_id

      t.timestamps
    end
    add_index :character_orchestrions, :character_id
    add_index :character_orchestrions, :orchestrion_id
    add_index :character_orchestrions, [:character_id, :orchestrion_id], unique: true
  end
end
