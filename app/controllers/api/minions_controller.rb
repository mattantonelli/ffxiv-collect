class Api::MinionsController < ApiController
  def index
    query = Minion.summonable.ransack(@query)
    @minions = query.result.includes(:behavior, :race, :skill_type)
      .include_sources.order(patch: :desc, order: :desc, id: :desc).limit(params[:limit])
    @owned = Redis.current.hgetall(:minions)
  end

  def show
    @minion = Minion.include_sources.find_by(id: params[:id])
    @owned = { params[:id] => Redis.current.hget(:minions, params[:id]) }
    render_not_found unless @minion.present?
  end
end
