class AddItemIdToArmoires < ActiveRecord::Migration[6.1]
  def change
    add_column :armoires, :item_id, :integer, null: false
    add_index :armoires, :item_id
  end
end
