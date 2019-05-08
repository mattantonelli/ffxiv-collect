class CreateArmoireCategories < ActiveRecord::Migration[5.2]
  def change
    create_table :armoire_categories do |t|
      t.string :name_en, null: false
      t.string :name_de, null: false
      t.string :name_fr, null: false
      t.string :name_ja, null: false
      t.integer :order, null: false

      t.timestamps
    end
    add_index :armoire_categories, :name_en
    add_index :armoire_categories, :name_de
    add_index :armoire_categories, :name_fr
    add_index :armoire_categories, :name_ja
    add_index :armoire_categories, :order
  end
end
