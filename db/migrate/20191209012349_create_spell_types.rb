class CreateSpellTypes < ActiveRecord::Migration[5.2]
  def change
    create_table :spell_types do |t|
      t.string :name_en
      t.string :name_de
      t.string :name_fr
      t.string :name_ja

      t.timestamps
    end
    add_index :spell_types, :name_en
    add_index :spell_types, :name_de
    add_index :spell_types, :name_fr
    add_index :spell_types, :name_ja
  end
end
