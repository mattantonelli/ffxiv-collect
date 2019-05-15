class BardingsController < ApplicationController
  include ManualCollection

  def index
    @bardings = Barding.includes(sources: :type).order(patch: :desc, id: :desc).all
    @barding_ids = @character&.barding_ids || []
  end

  def add
    add_collectable(@character.bardings, Barding.find(params[:id]))
  end

  def remove
    remove_collectable(@character.bardings, params[:id])
  end
end
