class AddIconIdToAchievements < ActiveRecord::Migration[5.2]
  def change
    add_column :achievements, :icon_id, :integer
  end
end
