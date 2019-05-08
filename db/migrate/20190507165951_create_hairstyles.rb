class CreateHairstyles < ActiveRecord::Migration[5.2]
  def change
    create_table :hairstyles do |t|
      t.string :name_en, null: false
      t.string :name_de, null: false
      t.string :name_fr, null: false
      t.string :name_ja, null: false
      t.string :description_en, limit: 1000
      t.string :description_de, limit: 1000
      t.string :description_fr, limit: 1000
      t.string :description_ja, limit: 1000
      t.string :patch

      t.timestamps
    end
    add_index :hairstyles, :name_en
    add_index :hairstyles, :name_de
    add_index :hairstyles, :name_fr
    add_index :hairstyles, :name_ja
  end
end
