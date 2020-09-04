class AddMissingIndexes < ActiveRecord::Migration[5.2]
  def change
    add_index :orchestrions, :order
    add_index :spells, :order
  end
end
