class AddSkillCostToMinions < ActiveRecord::Migration[5.2]
  def change
    add_column :minions, :skill_cost, :integer, null: false
  end
end
