class AddIndexesToCharacters < ActiveRecord::Migration[6.1]
  def change
    add_index :characters, :public
    add_index :characters, :updated_at
  end
end
