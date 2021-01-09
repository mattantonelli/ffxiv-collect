class AddRewardIdAndEventToQuests < ActiveRecord::Migration[5.2]
  def change
    add_column :quests, :reward_id, :integer
    add_column :quests, :event, :boolean
  end
end
