class Api::FacewearController < ApiController
  def index
    query = Facewear.all.ransack(@query)
    @facewears = query.result.include_related.ordered.distinct.limit(params[:limit])
  end

  def show
    @facewear = Facewear.include_sources.find_by(id: params[:id])
    render_not_found unless @facewear.present?
  end
end
