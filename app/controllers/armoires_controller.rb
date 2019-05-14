class ArmoiresController < ApplicationController
  include ManualCollection

  def index
    @armoires = Armoire.includes(:category).all.order(patch: :desc, order: :desc)
    @armoire_ids = @character&.armoire_ids || []
    @categories = ArmoireCategory.all.order(:order)

    @category = params[:category].to_i
    @category = nil if @category < 1
  end

  def add
    add_collectable(@character.armoires, Armoire.find(params[:id]))
  end

  def remove
    remove_collectable(@character.armoires, params[:id])
  end
end
