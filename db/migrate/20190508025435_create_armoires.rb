class CreateArmoires < ActiveRecord::Migration[5.2]
  def change
    create_table :armoires do |t|
      t.string :name_en, null: false
      t.string :name_de, null: false
      t.string :name_fr, null: false
      t.string :name_ja, null: false
      t.integer :order, null: false
      t.string :patch
      t.integer :category_id, null: false

      t.timestamps
    end
    add_index :armoires, :name_en
    add_index :armoires, :name_de
    add_index :armoires, :name_fr
    add_index :armoires, :name_ja
    add_index :armoires, :order
    add_index :armoires, :patch
    add_index :armoires, :category_id
  end
end
