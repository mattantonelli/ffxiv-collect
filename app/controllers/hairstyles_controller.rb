class HairstylesController < ApplicationController
  include ManualCollection

  def index
    @q = Hairstyle.ransack(params[:q])
    @hairstyles = @q.result.include_sources.with_filters(cookies)
      .order(patch: :desc, id: :desc).distinct
    @types = source_types(:hairstyle)
    @hairstyle_ids = @character&.hairstyle_ids || []
  end

  def show
    @hairstyle = Hairstyle.include_sources.find(params[:id])
  end

  def add
    add_collectable(@character.hairstyles, Hairstyle.find(params[:id]))
  end

  def remove
    remove_collectable(@character.hairstyles, params[:id])
  end
end
