class AddDatabaseToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :database, :string, null: false, default: 'garland'
  end
end
