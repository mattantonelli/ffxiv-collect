class CreateSurveyRecordSeries < ActiveRecord::Migration[6.1]
  def change
    create_table :survey_record_series do |t|
      t.string :name_en
      t.string :name_de
      t.string :name_fr
      t.string :name_ja

      t.timestamps
    end
  end
end
