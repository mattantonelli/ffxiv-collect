class AddAchievementPointsToCharacters < ActiveRecord::Migration[5.2]
  def change
    add_column :characters, :achievement_points, :integer, default: 0
  end
end
