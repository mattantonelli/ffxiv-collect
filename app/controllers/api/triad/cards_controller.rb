class Api::Triad::CardsController < ApiController
  def index
    query = Card.all.ransack(@query)
    @cards = query.result.available.include_related.ordered.distinct.limit(params[:limit])
  end

  def show
    @card = Card.include_sources.find(params[:id])
  end
end
