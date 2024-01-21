class Api::Triad::DecksController < ApiController
  def index
    query = Deck.all.ransack(@query)
    @decks = query.result.include_related.ordered.distinct.limit(params[:limit])
  end

  def show
    @deck = Deck.find_by(id: params[:id])
    render_not_found unless @deck.present?
  end

  private
  def set_owned
    @owned = Redis.current.hgetall('cards')
  end
end
