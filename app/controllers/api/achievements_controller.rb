class Api::AchievementsController < ApiController
  def index
    query = Achievement.all.ransack(@query)
    @achievements = query.result.ordered.limit(params[:limit])
    @owned = Redis.current.hgetall(:achievements)
  end

  def show
    @achievement = Achievement.find_by(id: params[:id])
    @owned = { params[:id] => Redis.current.hget(:achievements, params[:id]) }
    render_not_found unless @achievement.present?
  end
end
