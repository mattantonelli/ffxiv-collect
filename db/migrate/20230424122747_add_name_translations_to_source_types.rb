class AddNameTranslationsToSourceTypes < ActiveRecord::Migration[6.1]
  def change
    rename_column :source_types, :name, :name_en
    add_column :source_types, :name_de, :string, null: false, unique: true
    add_column :source_types, :name_fr, :string, null: false, unique: true
    add_column :source_types, :name_ja, :string, null: false, unique: true
  end
end
