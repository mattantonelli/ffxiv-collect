class CreateGroupMemberships < ActiveRecord::Migration[6.1]
  def change
    create_table :group_memberships do |t|
      t.integer :group_id
      t.integer :character_id

      t.timestamps
    end
    add_index :group_memberships, :group_id
    add_index :group_memberships, :character_id
    add_index :group_memberships, [:group_id, :character_id], unique: true
  end
end
