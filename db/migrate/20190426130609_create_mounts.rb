class CreateMounts < ActiveRecord::Migration[5.2]
  def change
    create_table :mounts do |t|
      t.string :name_en, null: false
      t.string :name_de, null: false
      t.string :name_fr, null: false
      t.string :name_ja, null: false
      t.boolean :flying, null: false
      t.integer :order, null: false
      t.string :patch
      t.string :description_en, null: false
      t.string :description_de, null: false
      t.string :description_fr, null: false
      t.string :description_ja, null: false
      t.string :enhanced_description_en, null: false, limit: 1000
      t.string :enhanced_description_de, null: false, limit: 1000
      t.string :enhanced_description_fr, null: false, limit: 1000
      t.string :enhanced_description_ja, null: false, limit: 1000
      t.string :tooltip_en, null: false
      t.string :tooltip_de, null: false
      t.string :tooltip_fr, null: false
      t.string :tooltip_ja, null: false

      t.timestamps
    end
    add_index :mounts, :name_en
    add_index :mounts, :name_de
    add_index :mounts, :name_fr
    add_index :mounts, :name_ja
    add_index :mounts, :order
    add_index :mounts, :patch
  end
end
