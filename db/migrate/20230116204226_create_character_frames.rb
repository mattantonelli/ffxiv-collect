class CreateCharacterFrames < ActiveRecord::Migration[6.1]
  def change
    create_table :character_frames do |t|
      t.integer :character_id
      t.integer :frame_id

      t.timestamps
    end

    add_index :character_frames, :character_id
    add_index :character_frames, :frame_id
    add_index :character_frames, [:character_id, :frame_id], unique: true,
      name: 'character_id_and_frame_id'

    add_column :characters, :frames_count, :integer, default: 0
    add_index :characters, :frames_count
  end
end
