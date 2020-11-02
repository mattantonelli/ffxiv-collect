class AddVideoToMounts < ActiveRecord::Migration[5.2]
  def change
    add_column :mounts, :video, :string
  end
end
