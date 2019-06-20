class LeaderboardsController < ApplicationController
  before_action :set_shared

  def index
    @data_center = params[:data_center]

    if @data_center.present? && !params[:q][:server_eq].present?
      params[:q][:server_in] = Character.servers_by_data_center[@data_center]
    end

    @q = Character.visible.ransack(params[:q])
    @results = @q.result.or(Character.where(id: @character&.id))
      .where("#{@metric} > 0").order(@metric => :desc, id: :asc)
    @ranks = @results.pluck(:id)
  end

  def free_company
    @free_company = FreeCompany.find(params[:id])
    @results = @free_company.members.where("#{@metric} > 0").order(@metric => :desc, id: :desc)
    @ranks = @results.pluck(:id)

    if @results.length < 10
      flash.now[:notice_fixed] = 'Missing someone? Refer them today to start tracking their character.'
    end

    @results = @results.paginate(page: params[:page])
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
