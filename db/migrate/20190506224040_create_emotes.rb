class CreateEmotes < ActiveRecord::Migration[5.2]
  def change
    create_table :emotes do |t|
      t.string :name_en, null: false
      t.string :name_de, null: false
      t.string :name_fr, null: false
      t.string :name_ja, null: false
      t.string :patch
      t.integer :category_id, null: false

      t.timestamps
    end
    add_index :emotes, :name_en
    add_index :emotes, :name_de
    add_index :emotes, :name_fr
    add_index :emotes, :name_ja
    add_index :emotes, :category_id
  end
end
