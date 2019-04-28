class CreateMinionSkillTypes < ActiveRecord::Migration[5.2]
  def change
    create_table :minion_skill_types do |t|
      t.string :name_en, null: false
      t.string :name_de, null: false
      t.string :name_fr, null: false
      t.string :name_ja, null: false

      t.timestamps
    end
  end
end
