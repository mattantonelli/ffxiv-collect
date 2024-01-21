class AddUserUidToDecks < ActiveRecord::Migration[6.1]
  def change
    add_column :decks, :user_uid, :string
    add_index :decks, :user_uid
  end
end
