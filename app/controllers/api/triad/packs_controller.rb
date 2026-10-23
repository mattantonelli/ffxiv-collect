class Api::Triad::PacksController < ApiController
  def index
    query = Pack.all.ransack(@query)
    @packs = query.result.include_related.ordered.distinct.limit(params[:limit])
  end

  def show
    @pack = Pack.includes(cards: :type).find(params[:id])
  end

  private
  def set_owned
    @owned = Redis.current.hgetall('cards')
  end
end
