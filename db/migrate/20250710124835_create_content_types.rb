class CreateContentTypes < ActiveRecord::Migration[7.2]
  def change
    create_table :content_types do |t|
      t.string :name_en, null: false
      t.string :name_de, null: false
      t.string :name_fr, null: false
      t.string :name_ja, null: false
      t.boolean :instance, default: false

      t.timestamps
    end
    add_index :content_types, :instance
  end
end
