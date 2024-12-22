class CreateCharacterOutfits < ActiveRecord::Migration[7.2]
  def change
    create_table :character_outfits do |t|
      t.integer :character_id
      t.integer :outfit_id

      t.timestamps
    end

    add_index :character_outfits, :character_id
    add_index :character_outfits, :outfit_id
    add_index :character_outfits, [:character_id, :outfit_id], unique: true

    add_column :characters, :outfits_count, :integer, default: 0
    add_index :characters, :outfits_count
  end
end
