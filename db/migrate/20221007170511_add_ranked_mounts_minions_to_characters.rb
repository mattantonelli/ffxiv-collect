class AddRankedMountsMinionsToCharacters < ActiveRecord::Migration[6.1]
  def change
    add_column :characters, :ranked_mounts_count, :integer, default: 0
    add_column :characters, :ranked_minions_count, :integer, default: 0

    add_index :characters, :ranked_mounts_count
    add_index :characters, :ranked_minions_count
  end
end
