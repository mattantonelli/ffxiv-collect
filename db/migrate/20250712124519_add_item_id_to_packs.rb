class AddItemIdToPacks < ActiveRecord::Migration[7.2]
  def change
    add_column :packs, :item_id, :integer
    add_index :packs, :item_id
  end
end
