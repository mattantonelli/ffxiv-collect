class AddItemColumnsToAchievements < ActiveRecord::Migration[5.2]
  def change
    add_column :achievements, :item_id, :integer
    add_column :achievements, :item_name_en, :string
    add_column :achievements, :item_name_de, :string
    add_column :achievements, :item_name_fr, :string
    add_column :achievements, :item_name_ja, :string
  end
end
