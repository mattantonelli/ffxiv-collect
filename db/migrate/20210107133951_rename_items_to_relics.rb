class RenameItemsToRelics < ActiveRecord::Migration[5.2]
  def change
    rename_table :items, :relics

    rename_table :character_items, :character_relics
    rename_column :character_relics, :item_id, :relic_id

    rename_column :characters, :items_count, :relics_count
  end
end
