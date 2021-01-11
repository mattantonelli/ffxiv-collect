class MakeFashionDescriptionsOptional < ActiveRecord::Migration[5.2]
  def up
    change_column_null :fashions, :description_en, true
    change_column_null :fashions, :description_de, true
    change_column_null :fashions, :description_fr, true
    change_column_null :fashions, :description_ja, true
  end

  def down
    change_column_null :fashions, :description_en, false
    change_column_null :fashions, :description_de, false
    change_column_null :fashions, :description_fr, false
    change_column_null :fashions, :description_ja, false
  end
end
