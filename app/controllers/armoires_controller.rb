class ArmoiresController < ApplicationController
  include ManualCollection

  def index
    @q = Armoire.ransack(params[:q])
    @armoires = @q.result.includes(:category, sources: [:type, :related]).order(patch: :desc, order: :desc).distinct
    @types = source_types(:armoire)
    @armoire_ids = @character&.armoire_ids || []
    @categories = ArmoireCategory.all.order(:order)

    @category = params[:category].to_i
    @category = nil if @category < 1
  end

  def show
    @armoire = Armoire.find(params[:id])
  end

  def add
    add_collectable(@character.armoires, Armoire.find(params[:id]))
  end

  def remove
    remove_collectable(@character.armoires, params[:id])
  end
end
