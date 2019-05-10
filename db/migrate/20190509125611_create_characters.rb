class CreateCharacters < ActiveRecord::Migration[5.2]
  def change
    create_table :characters do |t|
      t.string :name, null: false
      t.string :server, null: false
      t.string :portrait, null: false
      t.string :avatar, null: false
      t.datetime :last_parsed, null: false
      t.integer :verified_user_id
      t.integer :achievements_count, default: 0
      t.integer :mounts_count, default: 0
      t.integer :minions_count, default: 0
      t.integer :orchestrions_count, default: 0
      t.integer :emotes_count, default: 0
      t.integer :bardings_count, default: 0
      t.integer :hairstyles_count, default: 0
      t.integer :armoires_count, default: 0

      t.timestamps
    end
  end
end
