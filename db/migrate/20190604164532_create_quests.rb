class CreateQuests < ActiveRecord::Migration[5.2]
  def change
    create_table :quests do |t|
      t.string :name_en
      t.string :name_de
      t.string :name_fr
      t.string :name_ja

      t.timestamps
    end
    add_index :quests, :name_en
  end
end
