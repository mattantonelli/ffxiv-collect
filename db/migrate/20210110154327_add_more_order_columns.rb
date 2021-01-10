class AddMoreOrderColumns < ActiveRecord::Migration[5.2]
  def change
    add_column :bardings, :order, :integer
    add_column :emotes, :order, :integer

    add_index :bardings, :order
    add_index :emotes, :order
  end
end
