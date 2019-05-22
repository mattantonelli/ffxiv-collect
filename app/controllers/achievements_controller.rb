class AchievementsController < ApplicationController
  include Collection
  before_action :verify_character!, only: :index
  before_action :check_achievements!, except: :show

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

  private
  def check_achievements!
    return unless @character.present?

    if @character.achievements_count == -1
      flash.now[:alert] = 'Achievements for this character are set to private. You can make your achievements public ' \
        "#{view_context.link_to('here', 'https://na.finalfantasyxiv.com/lodestone/my/setting/account/')}."
    elsif @character.achievements_count == 0
      flash.now[:alert] = 'Achievements are still being loaded for this character. ' \
        "Please #{view_context.link_to('Refresh', refresh_character_path, method: :post)} your character or check back later."
    end
  end
end
