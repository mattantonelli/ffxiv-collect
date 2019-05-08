class HairstylesController < ApplicationController
  def index
    @hairstyles = Hairstyle.order(patch: :desc, id: :desc).all
  end

  def show
    @hairstyle = Hairstyle.find(params[:id])
  end
end
