class AddBgmSamples < ActiveRecord::Migration[5.2]
  def change
    add_column :orchestrions, :sample, :string, null: false
    add_column :mounts, :bgm_sample, :string
  end
end
