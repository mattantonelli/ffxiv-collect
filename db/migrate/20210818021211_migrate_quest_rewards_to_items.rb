class MigrateQuestRewardsToItems < ActiveRecord::Migration[5.2]
  def up
    remove_column :quests, :reward_id
    add_column :items, :quest_id, :integer
    add_index :items, :quest_id
  end

  def down
    remove_column :items, :quest_id
    add_column :quests, :reward_id, :integer
    add_index :quests, :reward_id
  end
end
