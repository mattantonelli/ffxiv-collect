class IndexCharacterCounts < ActiveRecord::Migration[5.2]
  def change
    add_index :characters, :achievements_count
    add_index :characters, :achievement_points
    add_index :characters, :mounts_count
    add_index :characters, :minions_count
    add_index :characters, :orchestrions_count
    add_index :characters, :emotes_count
    add_index :characters, :bardings_count
    add_index :characters, :hairstyles_count
    add_index :characters, :armoires_count
  end
end
