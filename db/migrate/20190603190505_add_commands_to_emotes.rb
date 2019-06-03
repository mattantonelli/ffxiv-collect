class AddCommandsToEmotes < ActiveRecord::Migration[5.2]
  def change
    add_column :emotes, :command_en, :string
    add_column :emotes, :command_de, :string
    add_column :emotes, :command_fr, :string
    add_column :emotes, :command_ja, :string
  end
end
