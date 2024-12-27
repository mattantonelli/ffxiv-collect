class AddIndexesToItemNames < ActiveRecord::Migration[7.2]
  def change
    add_index :items, :name_de
    add_index :items, :name_fr
    add_index :items, :name_ja
  end
end
