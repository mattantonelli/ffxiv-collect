class CreateActualItems < ActiveRecord::Migration[5.2]
  def change
    create_table :items do |t|
      t.string :name_en, null: false
      t.string :name_de, null: false
      t.string :name_fr, null: false
      t.string :name_ja, null: false
      t.string :description_en, limit: 1000, null: false
      t.string :description_de, limit: 1000, null: false
      t.string :description_fr, limit: 1000, null: false
      t.string :description_ja, limit: 1000, null: false
      t.string :icon_id, limit: 6
      t.boolean :tradeable
      t.string :unlock_type
      t.integer :unlock_id
      t.string :crafter
      t.integer :recipe_id

      t.timestamps
    end
    add_index :items, :name_en
    add_index :items, :unlock_type
  end
end
