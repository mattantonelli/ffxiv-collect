class AddItemIdsToCards < ActiveRecord::Migration[7.2]
  def change
      add_column :cards, :item_id, :integer
      add_index :cards, :item_id
  end
end
