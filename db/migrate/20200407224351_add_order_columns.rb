class AddOrderColumns < ActiveRecord::Migration[5.2]
  def change
    add_column :achievement_types, :order, :integer 
    add_column :achievement_categories, :order, :integer 
    add_column :orchestrion_categories, :order, :integer 

    add_index :achievement_types, :order
    add_index :achievement_categories, :order
    add_index :orchestrion_categories, :order
  end
end
