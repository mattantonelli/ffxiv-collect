class AchievementsController < ApplicationController
  def index
    @types = AchievementType.all.order(:id).includes(:categories)
  end

  def show
    @achievement = Achievement.find(params[:id])
  end

  def type
    @categories = AchievementType.find(params[:id]).categories.includes(:achievements)
  end
end
