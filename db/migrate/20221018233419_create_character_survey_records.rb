class CreateCharacterSurveyRecords < ActiveRecord::Migration[6.1]
  def change
    create_table :character_survey_records do |t|
      t.integer :character_id
      t.integer :survey_record_id

      t.timestamps
    end

    add_index :character_survey_records, :character_id
    add_index :character_survey_records, :survey_record_id
    add_index :character_survey_records, [:character_id, :survey_record_id], unique: true,
      name: 'character_id_and_survey_record_id'

    add_column :characters, :survey_records_count, :integer, default: 0
    add_index :characters, :survey_records_count
  end
end
