class AddContentIdToInstances < ActiveRecord::Migration[7.2]
  def change
    add_column :instances, :content_id, :integer
  end
end
