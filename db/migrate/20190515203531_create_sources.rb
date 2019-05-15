class CreateSources < ActiveRecord::Migration[5.2]
  def change
    create_table :sources do |t|
      t.integer :collectable_id, null: false
      t.string :collectable_type, null: false
      t.string :text
      t.integer :type_id, null: false

      t.timestamps
    end

    add_index :sources, [:collectable_id, :collectable_type]
    add_index :sources, :type_id
  end
end
