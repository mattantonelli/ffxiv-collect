class CreateFrames < ActiveRecord::Migration[6.1]
  def change
    create_table :frames do |t|
      t.string :name_en, null: false
      t.string :name_de, null: false
      t.string :name_fr, null: false
      t.string :name_ja, null: false
      t.string :patch
      t.integer :item_id

      t.timestamps
    end
    add_index :frames, :name_en
    add_index :frames, :name_de
    add_index :frames, :name_fr
    add_index :frames, :name_ja
    add_index :frames, :patch
    add_index :frames, :item_id
  end
end
