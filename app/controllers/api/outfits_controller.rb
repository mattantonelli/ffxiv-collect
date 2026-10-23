class Api::OutfitsController < ApiController
  def index
    query = Outfit.all.ransack(@query)
    @outfits = query.result.available.include_related.ordered.distinct.limit(params[:limit])
  end

  def show
    @outfit = Outfit.include_sources.find(params[:id])
  end
end
