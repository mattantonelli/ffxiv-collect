class Api::RelicsController < ApiController
  skip_before_action :set_owned

  def index
    query = Relic.all.ransack(@query)
    @relics = query.result.include_related.ordered.distinct.limit(params[:limit])
  end

  def show
    @relic = Relic.find_by(id: params[:id])
    render_not_found unless @relic.present?
  end
end
