class FixCardsIndexes < ActiveRecord::Migration[6.1]
  def change
    remove_index :cards, [:id, :patch]
    add_index :cards, :patch
  end
end
