class AddEnhancedDescriptionsToMinions < ActiveRecord::Migration[5.2]
  def change
    add_column :minions, :enhanced_description_en, :string, limit: 1000, null: false
    add_column :minions, :enhanced_description_de, :string, limit: 1000, null: false
    add_column :minions, :enhanced_description_fr, :string, limit: 1000, null: false
    add_column :minions, :enhanced_description_ja, :string, limit: 1000, null: false
  end
end
