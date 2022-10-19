class CreateSurveyRecords < ActiveRecord::Migration[6.1]
  def change
    create_table :survey_records do |t|
      t.string :name_en
      t.string :name_de
      t.string :name_fr
      t.string :name_ja
      t.text :description_en
      t.text :description_de
      t.text :description_fr
      t.text :description_ja
      t.string :solution, limit: 1000
      t.string :patch
      t.integer :series_id

      t.timestamps
    end
    add_index :survey_records, :series_id
  end
end
