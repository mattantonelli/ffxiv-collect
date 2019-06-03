class AddRelatedIdToSources < ActiveRecord::Migration[5.2]
  def change
    add_column :sources, :related_id, :integer
  end
end
