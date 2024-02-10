class ChangeLevesCategoryToCategoryId < ActiveRecord::Migration[6.1]
  def up
    remove_index :leves, :category
    rename_column :leves, :category, :category_id
    change_column :leves, :category_id, :integer
    add_index :leves, :category_id

    remove_column :leves, :craft
  end

  def down
    remove_index :leves, :category_id
    rename_column :leves, :category_id, :category
    change_column :leves, :category, :string
    add_index :leves, :category

    add_column :leves, :craft, :string
    add_index :leves, :craft
  end
end
