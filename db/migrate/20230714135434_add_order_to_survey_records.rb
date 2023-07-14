class AddOrderToSurveyRecords < ActiveRecord::Migration[6.1]
  def change
    add_column :survey_records, :order, :integer
    add_index :survey_records, :order
  end
end
