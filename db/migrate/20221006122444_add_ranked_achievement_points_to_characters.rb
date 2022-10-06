class AddRankedAchievementPointsToCharacters < ActiveRecord::Migration[6.1]
  def change
    add_column :characters, :ranked_achievement_points, :integer, default: 0
    add_index :characters, :ranked_achievement_points
  end
end
