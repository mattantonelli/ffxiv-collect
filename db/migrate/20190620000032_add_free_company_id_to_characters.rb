class AddFreeCompanyIdToCharacters < ActiveRecord::Migration[5.2]
  def change
    add_column :characters, :free_company_id, :string
    add_index :characters, :free_company_id
  end
end
