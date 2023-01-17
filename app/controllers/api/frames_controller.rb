class Api::FramesController < ApiController
  def index
    query = Frame.all.ransack(@query)
    @frames = query.result.include_related.ordered.distinct.limit(params[:limit])
  end

  def show
    @frame = Frame.find_by(id: params[:id])
    render_not_found unless @frame.present?
  end
end
