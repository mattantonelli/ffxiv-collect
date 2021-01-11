class AddDescriptionToArmoires < ActiveRecord::Migration[5.2]
  def change
    add_column :armoires, :description_en, :string
    add_column :armoires, :description_de, :string
    add_column :armoires, :description_fr, :string
    add_column :armoires, :description_ja, :string
  end
end
