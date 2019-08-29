class AchievementsController < ApplicationController
  include Collection
  before_action :verify_character!, only: :index
  before_action :check_achievements!, except: :show
  before_action :set_owned!, on: :items
  before_action :set_ids!, on: [:type, :items]

  def index
    @types = AchievementType.all.order(:id).includes(:categories, :achievements)
  end

  def show
    @achievement = Achievement.find(params[:id])
  end

  def type
    @type = AchievementType.find(params[:id])
    @achievements = @type.achievements
    @categories = @type.categories.includes(achievements: :title)
    @achievement_dates = @character&.character_achievements&.pluck(:achievement_id, :created_at).to_h || {}
  end

  def items
    @q = Achievement.where.not(item_id: nil).ransack(params[:q])
    @achievements = @q.result.order(patch: :desc, order: :desc).includes(category: :type)
    @owned = Redis.current.hgetall(:achievements)
  end
end
