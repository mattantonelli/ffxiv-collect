class AddBannedToCharacters < ActiveRecord::Migration[6.1]
  def change
    add_column :characters, :banned, :boolean, default: false
  end
end
