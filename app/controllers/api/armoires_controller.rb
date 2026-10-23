class Api::ArmoiresController < ApiController
  def index
    query = Armoire.all.ransack(@query)
    @armoires = query.result.available.include_related.ordered.distinct.limit(params[:limit])
  end

  def show
    @armoire = Armoire.include_sources.find(params[:id])
  end
end
