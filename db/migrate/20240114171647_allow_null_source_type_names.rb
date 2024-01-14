class AllowNullSourceTypeNames < ActiveRecord::Migration[6.1]
  def change
    change_column_null :source_types, :name_de, true
    change_column_null :source_types, :name_fr, true
    change_column_null :source_types, :name_ja, true
  end
end
