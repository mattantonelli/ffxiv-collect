class AddRelatedTypeToSources < ActiveRecord::Migration[5.2]
  def up
    add_column :sources, :related_type, :string
    add_index :sources, [:related_id, :related_type]

    Source.where.not(related_id: nil)
      .where(type: SourceType.find_by(name: 'Achievement'))
      .update_all(related_type: 'Achievement')
  end

  def down
    remove_index :sources, :related_type
    remove_column :sources, :related_type
  end
end
