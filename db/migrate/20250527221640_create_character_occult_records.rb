class CreateCharacterOccultRecords < ActiveRecord::Migration[7.2]
  def change
    create_table :character_occult_records do |t|
      t.integer :character_id
      t.integer :occult_record_id

      t.timestamps
    end

    add_index :character_occult_records, :character_id
    add_index :character_occult_records, :occult_record_id
    add_index :character_occult_records, [:character_id, :occult_record_id], unique: true,
      name: 'character_id_and_occult_record_id'

    add_column :characters, :occult_records_count, :integer, default: 0
    add_index :characters, :occult_records_count
  end
end
