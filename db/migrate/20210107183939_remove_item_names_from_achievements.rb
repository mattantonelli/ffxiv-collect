class RemoveItemNamesFromAchievements < ActiveRecord::Migration[5.2]
  def change
    remove_column :achievements, :item_name_en, :string
    remove_column :achievements, :item_name_de, :string
    remove_column :achievements, :item_name_fr, :string
    remove_column :achievements, :item_name_ja, :string
  end
end
