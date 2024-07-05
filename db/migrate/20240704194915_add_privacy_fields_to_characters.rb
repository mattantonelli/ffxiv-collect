class AddPrivacyFieldsToCharacters < ActiveRecord::Migration[6.1]
  def change
    add_column :characters, :public_mounts, :boolean, default: true
    add_column :characters, :public_minions, :boolean, default: true
    add_column :characters, :public_facewear, :boolean, default: true
  end
end
