class AddLastRankedAchievementTimeToCharacters < ActiveRecord::Migration[6.1]
  def change
    add_column :characters, :last_ranked_achievement_time, :datetime
    add_index :characters, :last_ranked_achievement_time
  end
end
