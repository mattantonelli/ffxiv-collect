class AddFieldsToRelics < ActiveRecord::Migration[6.1]
  def change
    add_column :relics, :order, :integer
    add_index :relics, :order
    add_column :relics, :type_id, :integer
    add_index :relics, :type_id
    add_column :relics, :achievement_id, :integer
    add_index :relics, :achievement_id
  end
end
