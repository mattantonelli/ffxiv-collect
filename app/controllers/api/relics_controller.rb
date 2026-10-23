class Api::RelicsController < ApiController
  def index
    query = Relic.all.ransack(@query)
    @relics = query.result.include_related.ordered.distinct.limit(params[:limit])
  end

  def show
    @relic = Relic.find(params[:id])
  end
end
