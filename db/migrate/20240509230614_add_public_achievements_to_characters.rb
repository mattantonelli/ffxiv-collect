class AddPublicAchievementsToCharacters < ActiveRecord::Migration[6.1]
  def change
    add_column :characters, :public_achievements, :boolean, default: false
  end
end
