class Api::ArmoiresController < ApiController
  def index
    query = Armoire.all.ransack(@query)
    @armoires = query.result.include_related.ordered.distinct.limit(params[:limit])
  end

  def show
    @armoire = Armoire.include_sources.find_by(id: params[:id])
    render_not_found unless @armoire.present?
  end
end
