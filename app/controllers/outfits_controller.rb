class OutfitsController < ApplicationController
  include ManualCollection

  def index
    @q = Outfit.ransack(params[:q])
    @outfits = @q.result.include_related.with_filters(cookies, @character).ordered.distinct
    @types = source_types(:outfit)
  end

  def show
    @outfit = Outfit.include_sources.find(params[:id])
  end

  def add
    add_collectable(@character.outfits, Outfit.find(params[:id]))
  end

  def remove
    remove_collectable(@character.outfits, params[:id])
  end
end
