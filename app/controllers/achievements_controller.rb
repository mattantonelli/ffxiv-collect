class AchievementsController < ApplicationController
  include Collection
  before_action :verify_character!, only: :index
  before_action :check_achievements!, except: :show
  before_action :set_owned!, on: :items
  before_action :set_ids!, :set_dates!, on: [:type, :items]
  skip_before_action :set_prices!

  def index
    @types = AchievementType.all.with_filters(cookies).ordered
    @achievements = @types.each_with_object({}) do |type, h|
      h[type.id] = type.achievements.with_filters(cookies)
    end
  end

  def show
    @achievement = Achievement.find(params[:id])
  end

  def type
    @type = AchievementType.find(params[:id])
    @categories = @type.categories.with_filters(cookies).ordered
    @achievements = @categories.each_with_object({}) do |category, h|
      h[category.id] = category.achievements.with_filters(cookies).includes(:item, :title).ordered
    end
  end

  def items
    @q = Achievement.where.not(item_id: nil).with_filters(cookies).ransack(params[:q])
    @achievements = @q.result.ordered
    @owned = {
      count: Redis.current.hgetall('achievements-count'),
      percentage: Redis.current.hgetall('achievements')
    }
  end

  def search
    @search = params[:q] || { patch_eq: Achievement.all.maximum(:patch) }
    @search.delete(:patch_eq) if @search[:patch_eq] == 'all'
    @q = Achievement.with_filters(cookies).ransack(@search)
    @achievements = @q.result.ordered

    @patches = Achievement.pluck(:patch).compact.uniq.sort.reverse
    @types = AchievementType.all.ordered
  end
end
