class LeaderboardsController < ApplicationController
  before_action :set_shared

  def index
    @data_center = params[:data_center]
    @limit = params[:limit] || 10

    if @data_center.present? && !params.dig(:q, :server_eq).present?
      params[:q] = { server_in: Character.servers_by_data_center[@data_center] }
    end

    @q = Character.visible.ransack(params[:q])
    @results = @q.result.or(Character.where(id: @character&.id))
      .where("#{@metric} > 0").order(@metric => :desc, id: :asc)
    @character_rank = @results.pluck(:id).index(@character&.id).try(:+, 1)
    @results = @results.limit(@limit)
  end

  def free_company
    @free_company = FreeCompany.find(params[:id])
    @results = @free_company.members.visible.where("#{@metric} > 0").order(@metric => :desc, id: :desc)
    @ranks = @results.pluck(:id)
  end

  private
  def set_shared
    @category = params[:category]&.downcase || 'achievement_points'

    if @category == 'achievement_points'
      @metric = 'achievement_points'
    else
      @metric = "#{@category}_count"
    end
  end
end
