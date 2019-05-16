class BardingsController < ApplicationController
  include ManualCollection

  def index
    @q = Barding.ransack(params[:q])
    @bardings = @q.result.includes(sources: :type).order(patch: :desc, id: :desc).distinct
    @types = source_types(:barding)
    @barding_ids = @character&.barding_ids || []
  end

  def add
    add_collectable(@character.bardings, Barding.find(params[:id]))
  end

  def remove
    remove_collectable(@character.bardings, params[:id])
  end
end
