class CreateOrchestrionCategories < ActiveRecord::Migration[5.2]
  def change
    create_table :orchestrion_categories do |t|
      t.string :name_en, null: false
      t.string :name_de, null: false
      t.string :name_fr, null: false
      t.string :name_ja, null: false

      t.timestamps
    end
    add_index :orchestrion_categories, :name_en
    add_index :orchestrion_categories, :name_de
    add_index :orchestrion_categories, :name_fr
    add_index :orchestrion_categories, :name_ja
  end
end
