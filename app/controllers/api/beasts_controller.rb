class Api::BeastsController < ApiController
  def index
    query = Beast.all.ransack(@query)
    @beasts = query.result.available.include_related.ordered.distinct.limit(params[:limit])
  end

  def show
    @beast = Beast.include_sources.find(params[:id])
  end
end
