class AddTradeableToOutfits < ActiveRecord::Migration[7.2]
  def change
    add_column :outfits, :tradeable, :boolean, default: false
  end
end
