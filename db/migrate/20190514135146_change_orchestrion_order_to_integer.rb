class ChangeOrchestrionOrderToInteger < ActiveRecord::Migration[5.2]
  def change
    change_column :orchestrions, :order, :integer
  end
end
