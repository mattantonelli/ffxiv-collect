class CreateGroups < ActiveRecord::Migration[6.1]
  def change
    create_table :groups do |t|
      t.string :slug, null: false
      t.string :name, null: false
      t.string :description
      t.boolean :public, default: true
      t.integer :owner_id, null: false
      t.datetime :queued_at, default: Time.at(0)

      t.timestamps
    end
    add_index :groups, :slug, unique: true
    add_index :groups, :owner_id
  end
end
