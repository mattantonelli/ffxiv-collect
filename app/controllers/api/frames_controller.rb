class Api::FramesController < ApiController
  def index
    query = Frame.all.ransack(@query)
    @frames = query.result.available.include_related.ordered.distinct.limit(params[:limit])
  end

  def show
    @frame = Frame.find(params[:id])
  end
end
