class CreateMinions < ActiveRecord::Migration[5.2]
  def change
    create_table :minions do |t|
      t.string :name_en, null: false
      t.string :name_de, null: false
      t.string :name_fr, null: false
      t.string :name_ja, null: false
      t.integer :cost, null: false
      t.integer :attack, null: false
      t.integer :defense, null: false
      t.integer :hp, null: false
      t.integer :speed, null: false
      t.boolean :area_attack, null: false
      t.integer :skill_angle, null: false
      t.boolean :arcana, null: false
      t.boolean :eye, null: false
      t.boolean :gate, null: false
      t.boolean :shield, null: false
      t.string :patch
      t.integer :behavior_id, null: false
      t.integer :race_id, null: false
      t.integer :skill_type_id
      t.string :description_en, null: false, limit: 1000
      t.string :description_de, null: false, limit: 1000
      t.string :description_fr, null: false, limit: 1000
      t.string :description_ja, null: false, limit: 1000
      t.string :tooltip_en, null: false
      t.string :tooltip_de, null: false
      t.string :tooltip_fr, null: false
      t.string :tooltip_ja, null: false
      t.string :skill_en, null: false
      t.string :skill_de, null: false
      t.string :skill_fr, null: false
      t.string :skill_ja, null: false
      t.string :skill_description_en, null: false
      t.string :skill_description_de, null: false
      t.string :skill_description_fr, null: false
      t.string :skill_description_ja, null: false

      t.timestamps
    end
    add_index :minions, :name_en
    add_index :minions, :name_de
    add_index :minions, :name_fr
    add_index :minions, :name_ja
    add_index :minions, :behavior_id
    add_index :minions, :race_id
    add_index :minions, :skill_type_id
  end
end
