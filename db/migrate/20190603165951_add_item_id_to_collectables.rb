class AddItemIdToCollectables < ActiveRecord::Migration[5.2]
  def change
    add_column :mounts, :item_id, :integer
    add_column :minions, :item_id, :integer
    add_column :orchestrions, :item_id, :integer
    add_column :emotes, :item_id, :integer
    add_column :bardings, :item_id, :integer
    add_column :hairstyles, :item_id, :integer
  end
end
