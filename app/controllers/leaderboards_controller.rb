class LeaderboardsController < ApplicationController
  before_action :set_shared

  def index
    @limit = params[:limit] || 10
    @rankings = Character.leaderboards(characters: Character.visible, metric: @metric, data_center: params[:data_center],
                                      server: params[:server], limit: @limit)
  end

  def free_company
    @free_company = FreeCompany.find(params[:id])
    @rankings = Character.leaderboards(characters: @free_company.members.visible, metric: @metric,
                                       data_center: params[:data_center], server: params[:server], limit: @limit)
  end

  private
  def set_shared
    @category = params[:category]&.downcase || 'ranked_achievement_points'

    if @category.match?('points')
      @metric = @category
    else
      @metric = "#{@category}_count"
    end
  end
end
