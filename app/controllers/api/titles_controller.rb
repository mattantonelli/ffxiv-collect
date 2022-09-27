class Api::TitlesController < ApiController
  skip_before_action :set_owned

  def index
    query = Title.include_related.all.ransack(@query)
    @titles = query.result.ordered.distinct.limit(params[:limit])
    @owned = Redis.current.hgetall('achievements')
  end

  def show
    @title = Title.find_by(id: params[:id])
    @owned = { @title.achievement_id.to_s => Redis.current.hget('achievements', params[:id]) }
    render_not_found unless @title.present?
  end
end
