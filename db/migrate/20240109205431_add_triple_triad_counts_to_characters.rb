class AddTripleTriadCountsToCharacters < ActiveRecord::Migration[6.1]
  def change
    add_column :characters, :cards_count, :integer, default: 0
    add_index  :characters, :cards_count

    add_column :characters, :npcs_count, :integer, default: 0
    add_index  :characters, :npcs_count
  end
end
