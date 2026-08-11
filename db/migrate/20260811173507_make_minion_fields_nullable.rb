class MakeMinionFieldsNullable < ActiveRecord::Migration[8.1]
  def change
    change_column_null :minions, :description_en, true
    change_column_null :minions, :description_de, true
    change_column_null :minions, :description_fr, true
    change_column_null :minions, :description_ja, true

    change_column_null :minions, :tooltip_en, true
    change_column_null :minions, :tooltip_de, true
    change_column_null :minions, :tooltip_fr, true
    change_column_null :minions, :tooltip_ja, true

    change_column_null :minions, :skill_en, true
    change_column_null :minions, :skill_de, true
    change_column_null :minions, :skill_fr, true
    change_column_null :minions, :skill_ja, true

    change_column_null :minions, :skill_description_en, true
    change_column_null :minions, :skill_description_de, true
    change_column_null :minions, :skill_description_fr, true
    change_column_null :minions, :skill_description_ja, true

    change_column_null :minions, :enhanced_description_en, true
    change_column_null :minions, :enhanced_description_de, true
    change_column_null :minions, :enhanced_description_fr, true
    change_column_null :minions, :enhanced_description_ja, true
  end
end
