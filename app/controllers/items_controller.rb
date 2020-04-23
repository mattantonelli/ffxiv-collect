class ItemsController < ApplicationController
  include ManualCollection

  def add
    add_collectable(@character.items, Item.find(params[:id]))
  end

  def remove
    remove_collectable(@character.items, params[:id])
  end
end
