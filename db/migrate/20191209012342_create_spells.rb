class CreateSpells < ActiveRecord::Migration[5.2]
  def change
    create_table :spells do |t|
      t.string :name_en, null: false
      t.string :name_de, null: false
      t.string :name_fr, null: false
      t.string :name_ja, null: false
      t.string :description_en, null: false, limit: 1000
      t.string :description_de, null: false, limit: 1000
      t.string :description_fr, null: false, limit: 1000
      t.string :description_ja, null: false, limit: 1000
      t.string :tooltip_en, null: false, limit: 1000
      t.string :tooltip_de, null: false, limit: 1000
      t.string :tooltip_fr, null: false, limit: 1000
      t.string :tooltip_ja, null: false, limit: 1000
      t.integer :order
      t.integer :rank, null: false
      t.string :patch
      t.integer :type_id, null: false
      t.integer :aspect_id, null: false

      t.timestamps
    end
    add_index :spells, :name_en
    add_index :spells, :name_de
    add_index :spells, :name_fr
    add_index :spells, :name_ja
    add_index :spells, :type_id
    add_index :spells, :aspect_id
  end
end
