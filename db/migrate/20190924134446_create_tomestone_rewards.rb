class CreateTomestoneRewards < ActiveRecord::Migration[5.2]
  def change
    create_table :tomestone_rewards do |t|
      t.integer :cost
      t.integer :collectable_id
      t.string :collectable_type

      t.timestamps
    end

    add_index :tomestone_rewards, [:collectable_id, :collectable_type]
  end
end
