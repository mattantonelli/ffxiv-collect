class CreateOccultRecords < ActiveRecord::Migration[7.2]
  def change
    create_table :occult_records do |t|
      t.string :name_en
      t.string :name_de
      t.string :name_fr
      t.string :name_ja
      t.text :description_en
      t.text :description_de
      t.text :description_fr
      t.text :description_ja
      t.string :patch

      t.timestamps
    end
    add_index :occult_records, :name_en
    add_index :occult_records, :name_de
    add_index :occult_records, :name_fr
    add_index :occult_records, :name_ja
    add_index :occult_records, :patch
  end
end
