class Api::MinionsController < ApiController
  def index
    query = Minion.summonable.ransack(@query)
    @minions = query.result.include_related.ordered.distinct.limit(params[:limit])
  end

  def show
    @minion = Minion.include_sources.find_by(id: params[:id])
    render_not_found unless @minion.present?
  end
end
