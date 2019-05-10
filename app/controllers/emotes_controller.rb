class EmotesController < ApplicationController
  def index
    @emotes = Emote.includes(:category).order(patch: :desc, id: :desc).all
    @categories = EmoteCategory.all.order(:id)

    @category = params[:category].to_i
    @category = nil if @category < 1
  end
end
