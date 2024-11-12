class AddOrderGroupToArmoires < ActiveRecord::Migration[6.1]
  def change
    add_column :armoires, :order_group, :integer
    add_index :armoires, :order_group
  end
end
