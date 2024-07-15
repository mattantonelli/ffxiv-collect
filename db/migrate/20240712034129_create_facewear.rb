class CreateFacewear < ActiveRecord::Migration[6.1]
  def change
    create_table :facewear do |t|
      t.string :name_en, null: false
      t.string :name_de, null: false
      t.string :name_fr, null: false
      t.string :name_ja, null: false
      t.integer :order, null: false
      t.string :patch
      t.integer :item_id

      t.timestamps
    end
    add_index :facewear, :name_en
    add_index :facewear, :name_de
    add_index :facewear, :name_fr
    add_index :facewear, :name_ja
    add_index :facewear, :patch
    add_index :facewear, :order
  end
end
