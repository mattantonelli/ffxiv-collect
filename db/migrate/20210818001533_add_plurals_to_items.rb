class AddPluralsToItems < ActiveRecord::Migration[5.2]
  def change
    add_column :items, :plural_en, :string
    add_column :items, :plural_de, :string
    add_column :items, :plural_fr, :string
    add_column :items, :plural_ja, :string
  end
end
