class AchievementsController < ApplicationController
  include Collection
  before_action :verify_character!, only: :index
  before_action :check_achievements!, except: :show
  before_action :set_owned!, on: :items
  before_action :set_ids!, :set_dates!, on: [:type, :items]

  def index
    @types = AchievementType.all.order(:order).includes(:categories, :achievements)
  end

  def show
    @achievement = Achievement.find(params[:id])
  end

  def type
    @type = AchievementType.find(params[:id])
    @achievements = @type.achievements
    @categories = @type.categories.includes(achievements: :title).order(:order)
  end

  def items
    @q = Achievement.where.not(item_id: nil).with_filters(cookies).ransack(params[:q])
    @achievements = @q.result.joins(category: :type).includes(:item, category: :type).ordered
    @owned = Redis.current.hgetall(:achievements)
  end

  def search
    @q = Achievement.with_filters(cookies).ransack(params[:q])

    if params[:q].present?
      @achievements = @q.result
    else
      # Default search results to the latest patch
      @achievements = Achievement.where(patch: Achievement.all.maximum(:patch))
    end

    @achievements = @achievements.joins(category: :type).includes(:item, :title, category: :type).ordered
  end
end
