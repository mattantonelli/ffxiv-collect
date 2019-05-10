class CreateCharacterHairstyles < ActiveRecord::Migration[5.2]
  def change
    create_table :character_hairstyles do |t|
      t.integer :character_id
      t.integer :hairstyle_id

      t.timestamps
    end
    add_index :character_hairstyles, :character_id
    add_index :character_hairstyles, :hairstyle_id
    add_index :character_hairstyles, [:character_id, :hairstyle_id], unique: true
  end
end
