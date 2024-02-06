class CreateLeves < ActiveRecord::Migration[6.1]
  def change
    create_table :leves do |t|
      t.string :name_en, null: false
      t.string :name_de, null: false
      t.string :name_fr, null: false
      t.string :name_ja, null: false
      t.string :craft, null: false
      t.string :category, null: false
      t.integer :level, null: false
      t.integer :location_id, null: false
      t.string :issuer_name_en, null: false
      t.string :issuer_name_de, null: false
      t.string :issuer_name_fr, null: false
      t.string :issuer_name_ja, null: false
      t.decimal :issuer_x, precision: 3, scale: 1, null: false
      t.decimal :issuer_y, precision: 3, scale: 1, null: false
      t.integer :item_id
      t.integer :item_quantity
      t.string :patch

      t.timestamps
    end

    add_index :leves, :name_en
    add_index :leves, :name_de
    add_index :leves, :name_fr
    add_index :leves, :name_ja
    add_index :leves, :craft
    add_index :leves, :category
    add_index :leves, :location_id
    add_index :leves, :item_id
    add_index :leves, :patch

    create_table "character_leves" do |t|
      t.integer "leve_id"
      t.integer "character_id"
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
      t.index ["leve_id"], name: "index_character_leves_on_leve_id"
      t.index ["character_id", "leve_id"], name: "index_character_leves_on_character_id_and_leve_id", unique: true
      t.index ["character_id"], name: "index_character_achievements_on_character_id"
    end

    add_column :characters, :leves_count, :integer, default: 0
    add_index  :characters, :leves_count
  end
end
