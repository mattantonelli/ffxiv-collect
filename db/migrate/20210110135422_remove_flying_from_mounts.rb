class RemoveFlyingFromMounts < ActiveRecord::Migration[5.2]
  def change
    remove_column :mounts, :flying, :boolean, null: false
  end
end
