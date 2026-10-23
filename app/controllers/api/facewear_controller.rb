class Api::FacewearController < ApiController
  def index
    query = Facewear.all.ransack(@query)
    @facewears = query.result.available.include_related.ordered.distinct.limit(params[:limit])
  end

  def show
    @facewear = Facewear.include_sources.find(params[:id])
  end
end
