class Api::BardingsController < ApiController
  def index
    query = Barding.all.ransack(@query)
    @bardings = query.result.available.include_related.ordered.distinct.limit(params[:limit])
  end

  def show
    @barding = Barding.include_sources.find(params[:id])
  end
end
