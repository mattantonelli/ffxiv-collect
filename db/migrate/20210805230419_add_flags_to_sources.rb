class AddFlagsToSources < ActiveRecord::Migration[5.2]
  def change
    add_column :sources, :premium, :boolean, default: false
    add_column :sources, :limited, :boolean, default: false
    add_index :sources, :premium
    add_index :sources, :limited
  end
end
