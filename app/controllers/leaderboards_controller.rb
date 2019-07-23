class LeaderboardsController < ApplicationController
  before_action :set_shared
  before_action :verify_character_sync_status!

  def index
    @data_center = params[:data_center]
    @limit = params[:limit] || 10

    if @data_center.present? && !params[:q][:server_eq].present?
      params[:q][:server_in] = Character.servers_by_data_center[@data_center]
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
    @category = params[:category] || 'Achievement Points'

    if @category == 'Achievement Points'
      @metric = 'achievement_points'
    else
      @metric = "#{params[:category].downcase.pluralize}_count"
    end
  end
end
