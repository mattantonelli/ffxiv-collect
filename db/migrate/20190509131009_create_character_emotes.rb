class CreateCharacterEmotes < ActiveRecord::Migration[5.2]
  def change
    create_table :character_emotes do |t|
      t.integer :character_id
      t.integer :emote_id

      t.timestamps
    end
    add_index :character_emotes, :character_id
    add_index :character_emotes, :emote_id
    add_index :character_emotes, [:character_id, :emote_id], unique: true
  end
end
