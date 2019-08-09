class TitlesController < ApplicationController
  include Collection
  before_action :check_achievements!
  skip_before_action :set_owned!

  def index
    @q = Title.ransack(params[:q])
    @titles = @q.result.includes(achievement: { category: :type }).all.order('achievements.patch desc', order: :desc)

    if cookies[:limited] == 'hide'
      @titles = @titles.joins(:achievement).merge(Achievement.exclude_time_limited)
    end

    @achievement_ids = @character&.achievement_ids || []
    @owned = Redis.current.hgetall(:achievements)
  end
end
