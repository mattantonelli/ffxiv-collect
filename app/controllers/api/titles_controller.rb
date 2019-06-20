class Api::TitlesController < ApiController
  def index
    query = Title.includes(achievement: { category: :type }).all.ransack(@query)
    @titles = query.result.order('achievements.patch desc', order: :desc).limit(params[:limit])
    @owned = Redis.current.hgetall(:achievements)
  end

  def show
    @title = Title.find_by(id: params[:id])
    @owned = { params[:id] => Redis.current.hget(:achievements, params[:id]) }
    render_not_found unless @title.present?
  end
end
