class AchievementsController < ApplicationController
  include Collection
  before_action :verify_character!, only: :index
  before_action :check_achievements!, except: :show
  before_action :set_owned!, on: :items
  before_action :set_ids!, :set_dates!, on: [:type, :items]

  CRAFTING_GATHERING_CATEGORIES_ORDER = ['All Disciplines', 'Carpenter', 'Blacksmith', 'Armorer',
                                         'Goldsmith', 'Leatherworker', 'Weaver', 'Alchemist', 'Culinarian',
                                         'Miner', 'Botanist', 'Fisher'].freeze

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

    if @type.name_en == 'Crafting & Gathering'
      @categories = @categories.sort_by { |category| CRAFTING_GATHERING_CATEGORIES_ORDER.index(category.name_en) }
    end
  end

  def items
    @q = Achievement.where.not(item_id: nil).ransack(params[:q])
    @achievements = @q.result.order(patch: :desc, order: :desc).includes(category: :type)
    @owned = Redis.current.hgetall(:achievements)
  end
end
