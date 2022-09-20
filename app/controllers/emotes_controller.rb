class EmotesController < ApplicationController
  include ManualCollection
  include Attachable

  def index
    @q = Emote.ransack(params[:q])
    @emotes = @q.result.include_related.with_filters(cookies).ordered.distinct
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
