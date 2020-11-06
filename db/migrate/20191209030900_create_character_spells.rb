class CreateCharacterSpells < ActiveRecord::Migration[5.2]
  def change
    create_table :character_spells do |t|
      t.integer :character_id
      t.integer :spell_id

      t.timestamps
    end

    add_index :character_spells, :character_id
    add_index :character_spells, :spell_id
    add_index :character_spells, [:character_id, :spell_id], unique: true

    add_column :characters, :spells_count, :integer, default: 0
    add_index :characters, :spells_count
  end
end
