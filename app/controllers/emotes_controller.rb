class EmotesController < ApplicationController
  include ManualCollection

  def index
    @q = Emote.ransack(params[:q])
    @emotes = @q.result.includes(:category, sources: [:type, :related]).with_filters(cookies)
      .order(patch: :desc, id: :desc).distinct
    @types = source_types(:emote)
    @emote_ids = @character&.emote_ids || []
    @categories = EmoteCategory.all.order(:id)

    @category = params[:category].to_i
    @category = nil if @category < 1
  end

  def show
    @emote = Emote.find(params[:id])
  end

  def add
    add_collectable(@character.emotes, Emote.find(params[:id]))
  end

  def remove
    remove_collectable(@character.emotes, params[:id])
  end
end
