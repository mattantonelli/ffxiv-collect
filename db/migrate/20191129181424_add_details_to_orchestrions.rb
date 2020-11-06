class AddDetailsToOrchestrions < ActiveRecord::Migration[5.2]
  def change
    add_column :orchestrions, :details, :string
  end
end
