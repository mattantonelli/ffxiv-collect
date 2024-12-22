class Api::OutfitsController < ApiController
  def index
    query = Outfit.all.ransack(@query)
    @outfits = query.result.include_related.ordered.distinct.limit(params[:limit])
  end

  def show
    @outfit = Outfit.include_sources.find_by(id: params[:id])
    render_not_found unless @outfit.present?
  end
end
