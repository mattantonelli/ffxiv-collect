class ChangeAchievementIconIdToString < ActiveRecord::Migration[7.2]
  def up
    change_column :achievements, :icon_id, :string, limit: 6
  end

  def down
    change_column :achievements, :icon_id, :integer
  end
end
