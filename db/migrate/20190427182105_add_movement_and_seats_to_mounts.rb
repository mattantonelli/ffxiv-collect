class AddMovementAndSeatsToMounts < ActiveRecord::Migration[5.2]
  def change
    add_column :mounts, :movement, :string, null: false
    add_column :mounts, :seats, :integer, null: false
  end
end
