class ChangeContentTypeToContentTypeId < ActiveRecord::Migration[7.2]
  def up
    remove_column :instances, :content_type
    add_column :instances, :content_type_id, :integer, null: false
  end

  def down
    remove_column :instances, :content_type_id
    add_column :instances, :content_type, :string, null: false
  end
end
