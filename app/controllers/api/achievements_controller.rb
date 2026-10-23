class Api::AchievementsController < ApiController
  def index
    query = Achievement.all.ransack(@query)
    @achievements = query.result.available.include_related.ordered.limit(params[:limit])
  end

  def show
    @achievement = Achievement.find(params[:id])
  end
end
