class AddOrderToMinions < ActiveRecord::Migration[5.2]
  def change
    add_column :minions, :order, :integer
    add_index :minions, :order
  end
end
