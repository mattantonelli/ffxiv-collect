class ArmoiresController < ApplicationController
  include ManualCollection

  def index
    @q = Armoire.ransack(params[:q])
    @armoires = @q.result.include_related.with_filters(cookies, @character).ordered.distinct
    @types = source_types(:armoire)
    @categories = ArmoireCategory.all.order(:order)

    @category = params[:category].to_i
    @category = nil if @category < 1
  end

  def show
    @armoire = Armoire.include_sources.find(params[:id])
  end

  def add
    add_collectable(@character.armoires, Armoire.find(params[:id]))
  end

  def remove
    remove_collectable(@character.armoires, params[:id])
  end
end
