class AddLimitedToLeves < ActiveRecord::Migration[6.1]
  def change
    add_column :leves, :limited, :boolean, default: false
  end
end
