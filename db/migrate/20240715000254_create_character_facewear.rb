class CreateCharacterFacewear < ActiveRecord::Migration[6.1]
  def change
    create_table :character_facewear do |t|
      t.integer :character_id
      t.integer :facewear_id

      t.timestamps
    end

    add_index :character_facewear, :character_id
    add_index :character_facewear, :facewear_id
    add_index :character_facewear, [:character_id, :facewear_id], unique: true,
      name: 'character_id_and_facewear_id'

    add_column :characters, :facewear_count, :integer, default: 0
    add_index :characters, :facewear_count
  end
end
