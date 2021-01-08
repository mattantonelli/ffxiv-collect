class AddDescriptionToBardings < ActiveRecord::Migration[5.2]
  def change
    add_column :bardings, :description_en, :string
    add_column :bardings, :description_de, :string
    add_column :bardings, :description_fr, :string
    add_column :bardings, :description_ja, :string
  end
end
