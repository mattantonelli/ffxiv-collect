class MakeSourceTypeNameUnique < ActiveRecord::Migration[5.2]
  def up
    remove_index :source_types, :name
    add_index :source_types, :name, unique: true
  end

  def down
    remove_index :source_types, :name
    add_index :source_types, :name, unique: false
  end
end
