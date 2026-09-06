class EmotesController < ApplicationController
  include PrivateCollection
  include Tooltipable

  before_action -> { check_privacy!(:emotes) }, except: :tooltip

  def index
    @q = Emote.ransack(params[:q])
    @emotes = @q.result.available.include_related.with_filters(cookies).ordered.distinct
    @types = source_types(:emote)
    @categories = EmoteCategory.all.order(:id)
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
