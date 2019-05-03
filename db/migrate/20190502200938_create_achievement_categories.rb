class CreateAchievementCategories < ActiveRecord::Migration[5.2]
  def change
    create_table :achievement_categories do |t|
      t.string :name_en, null: false
      t.string :name_de, null: false
      t.string :name_fr, null: false
      t.string :name_ja, null: false
      t.integer :type_id, null: false

      t.timestamps
    end
    add_index :achievement_categories, :name_en
    add_index :achievement_categories, :name_de
    add_index :achievement_categories, :name_fr
    add_index :achievement_categories, :name_ja
    add_index :achievement_categories, :type_id
  end
end
