class CreateFreeCompanies < ActiveRecord::Migration[5.2]
  def change
    create_table :free_companies, id: :string do |t|
      t.string :name
      t.string :tag

      t.timestamps
    end
  end
end
