class AddVierableToHairstyles < ActiveRecord::Migration[5.2]
  def change
    add_column :hairstyles, :vierable, :boolean, default: false
  end
end
