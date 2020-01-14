class AddTomestoneToTomestoneRewards < ActiveRecord::Migration[5.2]
  def change
    add_column :tomestone_rewards, :tomestone, :string
    add_index :tomestone_rewards, :tomestone
  end
end
