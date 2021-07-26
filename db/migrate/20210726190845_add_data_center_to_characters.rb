class AddDataCenterToCharacters < ActiveRecord::Migration[5.2]
  def change
    add_column :characters, :data_center, :string
    add_index :characters, :data_center
  end
end
