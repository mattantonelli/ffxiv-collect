class MakeCharacterPortraitNullable < ActiveRecord::Migration[6.1]
  def change
    change_column_null :characters, :portrait, true
  end
end
