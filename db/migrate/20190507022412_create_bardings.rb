class CreateBardings < ActiveRecord::Migration[5.2]
  def change
    create_table :bardings do |t|
      t.string :name_en, null: false
      t.string :name_de, null: false
      t.string :name_fr, null: false
      t.string :name_ja, null: false
      t.string :patch

      t.timestamps
    end
    add_index :bardings, :name_en
    add_index :bardings, :name_de
    add_index :bardings, :name_fr
    add_index :bardings, :name_ja
  end
end
