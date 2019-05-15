class HairstylesController < ApplicationController
  include ManualCollection

  def index
    @hairstyles = Hairstyle.includes(sources: :type).order(patch: :desc, id: :desc).all
    @hairstyle_ids = @character&.hairstyle_ids || []
  end

  def show
    @hairstyle = Hairstyle.find(params[:id])
  end

  def add
    add_collectable(@character.hairstyles, Hairstyle.find(params[:id]))
  end

  def remove
    remove_collectable(@character.hairstyles, params[:id])
  end
end
