class AddOrderGroupToMounts < ActiveRecord::Migration[5.2]
  def change
    add_column :mounts, :order_group, :integer
  end
end
