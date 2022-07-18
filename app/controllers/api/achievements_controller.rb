class Api::AchievementsController < ApiController
  def index
    query = Achievement.all.ransack(@query)
    @achievements = query.result.include_related.ordered.limit(params[:limit])
  end

  def show
    @achievement = Achievement.find_by(id: params[:id])
    render_not_found unless @achievement.present?
  end
end
