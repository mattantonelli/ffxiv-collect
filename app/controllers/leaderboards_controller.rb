class LeaderboardsController < ApplicationController
  def index
    @category = params[:category] || 'Achievement Points'
    @data_center = params[:data_center]

    if @data_center.present? && !params[:q][:server_eq].present?
      params[:q][:server_in] = Character.servers_by_data_center[@data_center]
    end

    if @category == 'Achievement Points'
      @metric = 'achievement_points'
    else
      @metric = "#{params[:category].downcase.pluralize}_count"
    end

    @q = Character.visible.ransack(params[:q])
    @results = @q.result.or(Character.where(id: @character&.id)).where("#{@metric} > 0").order(@metric => :desc, id: :asc)
    @ranks = @results.pluck(:id)
  end
end
