class RelicsController < ApplicationController
  include Collection
  before_action :check_achievements!, except: :show
  skip_before_action :set_owned!, :set_ids!, :set_dates!

  def index
    @relic_weapons = AchievementCategory.find_by(name_en: 'Relic Weapons').achievements.order(:order).first(10)
    @anima_weapons = AchievementCategory.find_by(name_en: 'Anima Weapons').achievements.order(:order)
    @eureka_weapons = AchievementCategory.find_by(name_en: 'Eureka Weapons').achievements.order(:order)
    @collection_ids = @character&.achievement_ids || []
    @owned = Redis.current.hgetall('achievements')
    @dates = @character&.character_achievements&.pluck('achievement_id', :created_at).to_h || {}
  end
end
