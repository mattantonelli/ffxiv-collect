class Api::FashionsController < ApiController
  def index
    query = Fashion.all.ransack(@query)
    @fashions = query.result.available.include_related.ordered.distinct.limit(params[:limit])
  end

  def show
    @fashion = Fashion.include_sources.find(params[:id])
  end
end
