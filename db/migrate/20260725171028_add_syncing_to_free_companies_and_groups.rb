class AddSyncingToFreeCompaniesAndGroups < ActiveRecord::Migration[8.1]
  def change
    add_column :free_companies, :syncing, :boolean, default: false
    add_column :groups, :syncing, :boolean, default: false
  end
end
