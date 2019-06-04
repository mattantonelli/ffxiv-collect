class CreateInstances < ActiveRecord::Migration[5.2]
  def change
    create_table :instances do |t|
      t.string :name_en, null: false
      t.string :name_de, null: false
      t.string :name_fr, null: false
      t.string :name_ja, null: false
      t.string :content_type, null: false

      t.timestamps
    end
    add_index :instances, :name_en
    add_index :instances, :content_type
  end
end
