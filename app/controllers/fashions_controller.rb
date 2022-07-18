class FashionsController < ApplicationController
  include ManualCollection

  def index
    @q = Fashion.ransack(params[:q])
    @fashions = @q.result.include_related.with_filters(cookies).ordered.distinct
    @types = source_types(:fashion)
  end

  def show
    @fashion = Fashion.include_sources.find(params[:id])
  end

  def add
    add_collectable(@character.fashions, Fashion.find(params[:id]))
  end

  def remove
    remove_collectable(@character.fashions, params[:id])
  end
end
