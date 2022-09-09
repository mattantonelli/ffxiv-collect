class AddSearchIndexesToCharacters < ActiveRecord::Migration[6.1]
  def change
    add_index :characters, :name
    add_index :characters, :server
  end
end
