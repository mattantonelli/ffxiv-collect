class AddPortraitOnlyToFrames < ActiveRecord::Migration[7.2]
  def change
    add_column :frames, :portrait_only, :boolean, default: false
  end
end
