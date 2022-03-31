class Api::RelicsController < ApiController
  def index
    query = Relic.all.ransack(@query)
    @relics = query.result.joins(:type).order('relic_types.category, relic_types.expansion DESC, relics.order')
      .limit(params[:limit])
    @owned = Redis.current.hgetall(:relics)
  end

  def show
    @relic = Relic.find_by(id: params[:id])
    @owned = { params[:id] => Redis.current.hget(:relics, params[:id]) }
    render_not_found unless @relic.present?
  end
end
