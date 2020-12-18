class HairstylesController < ApplicationController
  include ManualCollection

  def index
    @q = Hairstyle.ransack(params[:q])
    @hairstyles = @q.result.include_sources.with_filters(cookies, @character)
      .order(patch: :desc, id: :desc).distinct
    @types = source_types(:hairstyle)
  end

  def show
    @hairstyle = Hairstyle.include_sources.find(params[:id])
    @screenshots = Dir.chdir(Rails.root.join('app/assets/images')) do
      Dir.glob("hairstyles/screenshots/#{params[:id]}/*.png").sort
    end
  end

  def add
    add_collectable(@character.hairstyles, Hairstyle.find(params[:id]))
  end

  def remove
    remove_collectable(@character.hairstyles, params[:id])
  end
end
