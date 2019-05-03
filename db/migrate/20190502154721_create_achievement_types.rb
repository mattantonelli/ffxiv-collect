class CreateAchievementTypes < ActiveRecord::Migration[5.2]
  def change
    create_table :achievement_types do |t|
      t.string :name_en, null: false
      t.string :name_de, null: false
      t.string :name_fr, null: false
      t.string :name_ja, null: false

      t.timestamps
    end
    add_index :achievement_types, :name_en
    add_index :achievement_types, :name_de
    add_index :achievement_types, :name_fr
    add_index :achievement_types, :name_ja
  end
end
