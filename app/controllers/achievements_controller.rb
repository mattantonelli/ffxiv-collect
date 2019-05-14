class AchievementsController < ApplicationController
  def index
    @types = AchievementType.all.order(:id).includes(:categories, :achievements)
    @achievement_ids = @character&.achievement_ids || []
  end

  def show
    @achievement = Achievement.find(params[:id])
  end

  def type
    @type = AchievementType.find(params[:id])
    @achievements = @type.achievements
    @categories = @type.categories.includes(:achievements)
    @achievement_ids = @character&.achievement_ids || []
    @achievement_dates = @character&.character_achievements&.pluck(:achievement_id, :created_at).to_h || {}
  end
end
