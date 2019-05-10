class AchievementsController < ApplicationController
  def index
    @types = AchievementType.all.order(:id).includes(:categories)
  end

  def show
    @achievement = Achievement.find(params[:id])
  end

  def type
    @type = AchievementType.find(params[:id])
    @achievements = @type.achievements
    @categories = @type.categories.includes(:achievements)
    @achievement_ids = current_user&.character&.achievement_ids || []
  end
end
