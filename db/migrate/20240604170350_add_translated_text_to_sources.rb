class AddTranslatedTextToSources < ActiveRecord::Migration[6.1]
  def change
    rename_column :sources, :text, :text_en
    add_column :sources, :text_de, :string
    add_column :sources, :text_fr, :string
    add_column :sources, :text_ja, :string
  end
end
