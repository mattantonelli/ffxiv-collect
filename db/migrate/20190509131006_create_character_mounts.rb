class CreateCharacterMounts < ActiveRecord::Migration[5.2]
  def change
    create_table :character_mounts do |t|
      t.integer :character_id
      t.integer :mount_id

      t.timestamps
    end
    add_index :character_mounts, :character_id
    add_index :character_mounts, :mount_id
    add_index :character_mounts, [:character_id, :mount_id], unique: true
  end
end
