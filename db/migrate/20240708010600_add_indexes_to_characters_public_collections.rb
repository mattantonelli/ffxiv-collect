class AddIndexesToCharactersPublicCollections < ActiveRecord::Migration[6.1]
  def change
    add_index :characters, :public_mounts
    add_index :characters, :public_minions
    add_index :characters, :public_facewear
  end
end
