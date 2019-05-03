class CreateAchievements < ActiveRecord::Migration[5.2]
  def change
    create_table :achievements do |t|
      t.string :name_en, null: false
      t.string :name_de, null: false
      t.string :name_fr, null: false
      t.string :name_ja, null: false
      t.string :description_en, null: false
      t.string :description_de, null: false
      t.string :description_fr, null: false
      t.string :description_ja, null: false
      t.integer :points, null: false
      t.integer :order, null: false
      t.string :patch
      t.integer :category_id, null: false
      t.string :title_en
      t.string :title_de
      t.string :title_fr
      t.string :title_ja

      t.timestamps
    end
    add_index :achievements, :name_en
    add_index :achievements, :name_de
    add_index :achievements, :name_fr
    add_index :achievements, :name_ja
    add_index :achievements, :order
    add_index :achievements, :category_id
  end
end
