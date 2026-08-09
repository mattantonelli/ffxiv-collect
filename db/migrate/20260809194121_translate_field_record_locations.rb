class TranslateFieldRecordLocations < ActiveRecord::Migration[8.1]
  def change
    rename_column :field_records, :location, :location_en
    add_column :field_records, :location_de, :string
    add_column :field_records, :location_fr, :string
    add_column :field_records, :location_ja, :string
    add_column :field_records, :location_tc, :string
  end
end
