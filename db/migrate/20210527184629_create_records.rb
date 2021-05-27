class CreateRecords < ActiveRecord::Migration[5.2]
  def change
    create_table :records do |t|
      t.string :name_en, null: false
      t.string :name_de, null: false
      t.string :name_fr, null: false
      t.string :name_ja, null: false
      t.text :description_en, null: false
      t.text :description_de, null: false
      t.text :description_fr, null: false
      t.text :description_ja, null: false
      t.integer :rarity, null: false
      t.string :patch
      t.integer :linked_record_id

      t.timestamps
    end

    add_index :records, :name_en
    add_index :records, :name_de
    add_index :records, :name_fr
    add_index :records, :name_ja
    add_index :records, :linked_record_id
  end
end
