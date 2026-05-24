class CreateCharacterApiTokens < ActiveRecord::Migration[7.2]
  def change
    create_table :character_api_tokens do |t|
      t.integer :character_id, null: false
      t.integer :user_id, null: false
      t.string :token_hash, null: false, limit: 64
      t.datetime :last_used_at
      t.string :last_user_agent, limit: 255

      t.timestamps
    end

    add_index :character_api_tokens, :character_id, unique: true
    add_index :character_api_tokens, :user_id
    add_index :character_api_tokens, :token_hash, unique: true
  end
end
