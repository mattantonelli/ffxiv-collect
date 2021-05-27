class AddLocationToRecords < ActiveRecord::Migration[5.2]
  def change
    add_column :records, :location, :string
  end
end
