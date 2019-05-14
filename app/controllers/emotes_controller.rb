class EmotesController < ApplicationController
  include ManualCollection

  def index
    @emotes = Emote.includes(:category).order(patch: :desc, id: :desc).all
    @emote_ids = @character&.emote_ids || []
    @categories = EmoteCategory.all.order(:id)

    @category = params[:category].to_i
    @category = nil if @category < 1
  end

  def add
    add_collectable(@character.emotes, Emote.find(params[:id]))
  end

  def remove
    remove_collectable(@character.emotes, params[:id])
  end
end
