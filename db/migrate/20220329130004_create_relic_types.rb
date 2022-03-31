class CreateRelicTypes < ActiveRecord::Migration[6.1]
  def change
    create_table :relic_types do |t|
      t.string :name_en
      t.string :name_de
      t.string :name_fr
      t.string :name_ja
      t.string :category
      t.integer :jobs
      t.integer :order
      t.integer :expansion

      t.timestamps
    end

    add_index :relic_types, :order
    add_index :relic_types, :expansion
  end
end
