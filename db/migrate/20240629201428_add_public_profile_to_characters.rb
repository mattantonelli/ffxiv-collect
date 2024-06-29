class AddPublicProfileToCharacters < ActiveRecord::Migration[6.1]
  def change
    add_column :characters, :public_profile, :boolean, default: true
  end
end
