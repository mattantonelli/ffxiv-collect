class CreateCharacterRecords < ActiveRecord::Migration[5.2]
  def change
    create_table :character_records do |t|
      t.integer :character_id
      t.integer :record_id

      t.timestamps
    end
    add_index :character_records, :character_id
    add_index :character_records, :record_id
    add_index :character_records, [:character_id, :record_id], unique: true

    add_column :characters, :records_count, :integer, default: 0
    add_index :characters, :records_count
  end
end
