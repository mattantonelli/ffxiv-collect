class TitlesController < ApplicationController
  include Collection
  before_action :check_achievements!
  skip_before_action :set_owned!

  def index
    @titles = Title.includes(achievement: { category: :type }).all.order('achievements.patch desc', order: :desc)

    if cookies[:limited] == 'hide'
      @titles = @titles.where('achievement_categories.type_id <> ?', AchievementType.find_by(name_en: 'Legacy').id)
        .where('achievements.category_id not in (?)', AchievementCategory.where(name_en: 'Seasonal Events').pluck(:id))
    end

    @achievement_ids = @character&.achievement_ids || []
    @owned = Redis.current.hgetall(:achievements)
  end
end
