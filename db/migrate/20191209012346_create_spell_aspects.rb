class CreateSpellAspects < ActiveRecord::Migration[5.2]
  def change
    create_table :spell_aspects do |t|
      t.string :name_en
      t.string :name_de
      t.string :name_fr
      t.string :name_ja

      t.timestamps
    end
    add_index :spell_aspects, :name_en
    add_index :spell_aspects, :name_de
    add_index :spell_aspects, :name_fr
    add_index :spell_aspects, :name_ja
  end
end
