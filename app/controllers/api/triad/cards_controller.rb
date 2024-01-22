class Api::Triad::CardsController < ApiController
  def index
    query = Card.all.ransack(@query)
    @cards = query.result.include_related.ordered.distinct.limit(params[:limit])
  end

  def show
    @card = Card.include_sources.find_by(id: params[:id])
    render_not_found unless @card.present?
  end
end
