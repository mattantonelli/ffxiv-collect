class AddHrothableToHairstyles < ActiveRecord::Migration[6.1]
  def change
    add_column :hairstyles, :hrothable, :boolean, default: false
  end
end
