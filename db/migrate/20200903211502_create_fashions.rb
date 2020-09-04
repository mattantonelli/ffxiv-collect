class CreateFashions < ActiveRecord::Migration[5.2]
  def change
    create_table :fashions do |t|
      t.string :name_en, null: false
      t.string :name_de, null: false
      t.string :name_fr, null: false
      t.string :name_ja, null: false
      t.string :description_en, null: false, limit: 1000
      t.string :description_de, null: false, limit: 1000
      t.string :description_fr, null: false, limit: 1000
      t.string :description_ja, null: false, limit: 1000
      t.integer :order, null: false
      t.string :patch
      t.integer :item_id

      t.timestamps
    end
    add_index :fashions, :name_en
    add_index :fashions, :name_de
    add_index :fashions, :name_fr
    add_index :fashions, :name_ja
    add_index :fashions, :order
    add_index :fashions, :patch
  end
end
