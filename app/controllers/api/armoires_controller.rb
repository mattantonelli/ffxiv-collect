class Api::ArmoiresController < ApiController
  def index
    query = Armoire.all.ransack(@query)
    @armoires = query.result.includes(:category).include_sources
      .order(patch: :desc, order: :desc).distinct.limit(params[:limit])
    @owned = Redis.current.hgetall(:armoires)
  end

  def show
    @armoire = Armoire.include_sources.find_by(id: params[:id])
    @owned = { params[:id] => Redis.current.hget(:armoires, params[:id]) }
    render_not_found unless @armoire.present?
  end
end
