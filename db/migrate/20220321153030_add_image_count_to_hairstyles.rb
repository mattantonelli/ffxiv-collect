class AddImageCountToHairstyles < ActiveRecord::Migration[6.1]
  def change
    add_column :hairstyles, :image_count, :integer, default: 0
  end
end
