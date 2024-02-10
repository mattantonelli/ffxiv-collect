class CreateLeveCategories < ActiveRecord::Migration[6.1]
  def change
    create_table :leve_categories do |t|
      t.string :name_en, null: false
      t.string :name_de, null: false
      t.string :name_fr, null: false
      t.string :name_ja, null: false
      t.string :craft_en, null: false
      t.string :craft_de, null: false
      t.string :craft_fr, null: false
      t.string :craft_ja, null: false
      t.string :order, null: false
      t.boolean :items, default: false

      t.timestamps
    end
    add_index :leve_categories, :name_en
    add_index :leve_categories, :name_de
    add_index :leve_categories, :name_fr
    add_index :leve_categories, :name_ja
    add_index :leve_categories, :craft_en
    add_index :leve_categories, :craft_de
    add_index :leve_categories, :craft_fr
    add_index :leve_categories, :craft_ja
    add_index :leve_categories, :order
  end
end
