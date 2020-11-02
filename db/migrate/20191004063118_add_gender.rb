class AddGender < ActiveRecord::Migration[5.2]
  def change
    add_column :characters, :gender, :string
    add_column :armoires, :gender, :string
    add_column :hairstyles, :gender, :string

    add_index :armoires, :gender
    add_index :hairstyles, :gender
  end
end
