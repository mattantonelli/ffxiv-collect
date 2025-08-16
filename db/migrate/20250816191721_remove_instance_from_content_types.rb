class RemoveInstanceFromContentTypes < ActiveRecord::Migration[7.2]
  def up
    remove_column :content_types, :instance, :boolean
  end

  def down
    add_column :content_types, :instance, :boolean, default: false
  end
end
