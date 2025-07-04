class RemoveBgmSamples < ActiveRecord::Migration[7.2]
  def up
    remove_column :mounts, :bgm_sample
    add_column :mounts, :custom_music, :boolean, default: false
    remove_column :orchestrions, :sample
  end

  def down
    remove_column :mounts, :custom_music
    add_column :mounts, :bgm_sample, :string
    add_column :orchestrions, :sample, :string, null: false
  end
end
