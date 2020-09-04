class Api::FashionsController < ApiController
  def index
    query = Fashion.all.ransack(@query)
    @fashions = query.result.include_sources
      .order(patch: :desc, order: :desc).distinct.limit(params[:limit])
    @owned = Redis.current.hgetall(:fashions)
  end

  def show
    @fashion = Fashion.include_sources.find_by(id: params[:id])
    @owned = { params[:id] => Redis.current.hget(:fashions, params[:id]) }
    render_not_found unless @fashion.present?
  end
end
