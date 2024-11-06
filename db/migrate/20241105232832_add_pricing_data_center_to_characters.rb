class AddPricingDataCenterToCharacters < ActiveRecord::Migration[6.1]
  def change
    add_column :characters, :pricing_data_center, :string
  end
end
