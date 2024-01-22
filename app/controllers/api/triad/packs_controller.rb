class Api::Triad::PacksController < ApiController
  def index
    query = Pack.all.ransack(@query)
    @packs = query.result.include_related.ordered.distinct.limit(params[:limit])
  end

  def show
    @pack = Pack.includes(cards: :type).find_by(id: params[:id])
    render_not_found unless @pack.present?
  end

  private
  def set_owned
    @owned = Redis.current.hgetall('cards')
  end
end
