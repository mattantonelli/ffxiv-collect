class TitlesController < ApplicationController
  include Collection
  before_action :check_achievements!
  skip_before_action :set_owned!

  def index
    @titles = Title.includes(achievement: { category: :type }).all.order('achievements.patch desc', order: :desc)
    @achievement_ids = @character&.achievement_ids || []
    @owned = Redis.current.hgetall(:achievements)
  end
end
