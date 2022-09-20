class BardingsController < ApplicationController
  include ManualCollection
  include Attachable

  def index
    @q = Barding.ransack(params[:q])
    @bardings = @q.result.include_related.with_filters(cookies).ordered.distinct
    @types = source_types(:barding)
  end

  def show
    @barding = Barding.include_sources.find(params[:id])
  end

  def add
    add_collectable(@character.bardings, Barding.find(params[:id]))
  end

  def remove
    remove_collectable(@character.bardings, params[:id])
  end
end
