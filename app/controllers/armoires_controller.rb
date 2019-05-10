class ArmoiresController < ApplicationController
  def index
    @armoires = Armoire.includes(:category).all.order(patch: :desc, order: :desc)
    @categories = ArmoireCategory.all.order(:order)

    @category = params[:category].to_i
    @category = nil if @category < 1
  end
end
