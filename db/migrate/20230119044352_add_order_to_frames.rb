class AddOrderToFrames < ActiveRecord::Migration[6.1]
  def change
    add_column :frames, :order, :integer
    add_index :frames, :order
  end
end
