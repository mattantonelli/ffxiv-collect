class CreateTitles < ActiveRecord::Migration[5.2]
  def up
    create_table :titles do |t|
      t.string :name_en, null: false
      t.string :name_de, null: false
      t.string :name_fr, null: false
      t.string :name_ja, null: false
      t.string :female_name_en, null: false
      t.string :female_name_de, null: false
      t.string :female_name_fr, null: false
      t.string :female_name_ja, null: false
      t.integer :order, null: false
      t.integer :achievement_id, null: false

      t.timestamps
    end
    add_index :titles, :achievement_id

    remove_column :achievements, :title_en
    remove_column :achievements, :title_de
    remove_column :achievements, :title_fr
    remove_column :achievements, :title_ja
  end

  def down
    add_column :achievements, :title_en, :string
    add_column :achievements, :title_de, :string
    add_column :achievements, :title_fr, :string
    add_column :achievements, :title_ja, :string
  end
end
