class BardingsController < ApplicationController
  include ManualCollection

  def index
    @q = Barding.ransack(params[:q])
    @bardings = @q.result.include_sources.with_filters(cookies)
      .order(patch: :desc, id: :desc).distinct
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
