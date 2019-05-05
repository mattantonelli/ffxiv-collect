class CreateOrchestrions < ActiveRecord::Migration[5.2]
  def change
    create_table :orchestrions do |t|
      t.string :name_en, null: false
      t.string :name_de, null: false
      t.string :name_fr, null: false
      t.string :name_ja, null: false
      t.string :description_en, null: false
      t.string :description_de, null: false
      t.string :description_fr, null: false
      t.string :description_ja, null: false
      t.string :order
      t.string :patch
      t.integer :category_id, null: false

      t.timestamps
    end
    add_index :orchestrions, :name_en
    add_index :orchestrions, :name_de
    add_index :orchestrions, :name_fr
    add_index :orchestrions, :name_ja
    add_index :orchestrions, :category_id
  end
end
