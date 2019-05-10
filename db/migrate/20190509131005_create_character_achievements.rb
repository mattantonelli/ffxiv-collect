class CreateCharacterAchievements < ActiveRecord::Migration[5.2]
  def change
    create_table :character_achievements do |t|
      t.integer :character_id
      t.integer :achievement_id

      t.timestamps
    end
    add_index :character_achievements, :character_id
    add_index :character_achievements, :achievement_id
    add_index :character_achievements, [:character_id, :achievement_id], unique: true
  end
end
