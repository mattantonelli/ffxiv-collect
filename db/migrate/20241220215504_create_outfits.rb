class CreateOutfits < ActiveRecord::Migration[7.2]
  def change
    create_table :outfits do |t|
      t.string :name_en, null: false
      t.string :name_de, null: false
      t.string :name_fr, null: false
      t.string :name_ja, null: false
      t.boolean :armoireable, default: false
      t.string :gender
      t.string :patch
      t.integer :item_id

      t.timestamps
    end

    add_index :outfits, :name_en
    add_index :outfits, :name_de
    add_index :outfits, :name_fr
    add_index :outfits, :name_ja
    add_index :outfits, :gender
    add_index :outfits, :patch
    add_index :outfits, :armoireable
  end
end
