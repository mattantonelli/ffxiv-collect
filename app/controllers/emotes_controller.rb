class EmotesController < ApplicationController
  include ManualCollection

  def index
    @q = Emote.ransack(params[:q])
    @emotes = @q.result.includes(:category).include_sources.with_filters(cookies)
      .order(patch: :desc, order: :desc).distinct
    @types = source_types(:emote)
    @categories = EmoteCategory.all.order(:id)

    @category = params[:category].to_i
    @category = nil if @category < 1
  end

  def show
    @emote = Emote.include_sources.find(params[:id])
  end

  def add
    add_collectable(@character.emotes, Emote.find(params[:id]))
  end

  def remove
    remove_collectable(@character.emotes, params[:id])
  end
end
