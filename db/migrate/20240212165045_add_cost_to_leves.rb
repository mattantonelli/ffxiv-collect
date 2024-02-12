class AddCostToLeves < ActiveRecord::Migration[6.1]
  def change
    add_column :leves, :cost, :integer, default: 1
  end
end
