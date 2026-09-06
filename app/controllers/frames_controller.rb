class FramesController < ApplicationController
  include ManualCollection
  include Tooltipable

  def index
    @q = Frame.ransack(params[:q])
    @frames = @q.result.available.include_related.with_filters(cookies).ordered.distinct
    @types = source_types(:frame)
  end

  def show
    @frame = Frame.include_sources.find(params[:id])
    @item = @frame.item
  end

  def add
    add_collectable(@character.frames, Frame.find(params[:id]))
  end

  def remove
    remove_collectable(@character.frames, params[:id])
  end
end
