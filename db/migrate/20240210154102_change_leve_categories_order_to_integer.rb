class ChangeLeveCategoriesOrderToInteger < ActiveRecord::Migration[6.1]
  def up
    change_column :leve_categories, :order, :integer
  end

  def down
    change_column :leve_categories, :order, :string
  end
end
