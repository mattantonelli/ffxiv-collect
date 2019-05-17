class AddMissingPatchIndexes < ActiveRecord::Migration[5.2]
  def change
    add_index :achievements, :patch
    add_index :bardings, :patch
    add_index :emotes, :patch
    add_index :hairstyles, :patch
    add_index :minions, :patch
    add_index :orchestrions, :patch
  end
end
