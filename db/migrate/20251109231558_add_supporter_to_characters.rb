class AddSupporterToCharacters < ActiveRecord::Migration[7.2]
  def change
    add_column :characters, :supporter, :boolean, default: false
  end
end
