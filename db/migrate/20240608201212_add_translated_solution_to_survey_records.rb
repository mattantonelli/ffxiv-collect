class AddTranslatedSolutionToSurveyRecords < ActiveRecord::Migration[6.1]
  def change
    rename_column :survey_records, :solution, :solution_en
    add_column :survey_records, :solution_de, :string, limit: 1000
    add_column :survey_records, :solution_fr, :string, limit: 1000
    add_column :survey_records, :solution_ja, :string, limit: 1000
  end
end
