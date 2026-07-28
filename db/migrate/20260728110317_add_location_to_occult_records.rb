class AddLocationToOccultRecords < ActiveRecord::Migration[8.1]
  def change
    add_column :occult_records, :location, :string
  end
end
