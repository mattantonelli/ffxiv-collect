class CreateOutfitItems < ActiveRecord::Migration[7.2]
  def change
    create_table :outfit_items do |t|
      t.integer :item_id
      t.integer :outfit_id
    end

    add_index :outfit_items, :item_id
    add_index :outfit_items, :outfit_id
  end
end
