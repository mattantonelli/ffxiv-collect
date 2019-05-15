class AddPublicToCharacters < ActiveRecord::Migration[5.2]
  def change
    add_column :characters, :public, :boolean, default: true
  end
end
