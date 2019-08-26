class MinionsController < ApplicationController
  include Collection
  before_action :set_ids!, on: :verminion

  def index
    @q = Minion.summonable.ransack(params[:q])
    @minions = @q.result.includes(:race)
      .include_sources.with_filters(cookies).order(patch: :desc, order: :desc).distinct
    @types = source_types(:minion)
  end

  def verminion
    if params[:strength].present?
      params[:q].merge!("#{params[:strength]}_true" => 1)
    end

    @q = Minion.verminion.ransack(params[:q])
    @minions = @q.result.includes(:race, :skill_type)
      .include_sources.with_filters(cookies).order(patch: :desc, order: :desc)
  end

  def show
    id = params[:id].to_i
    if Minion.unsummonable_ids.include?(id)
      id = Minion.parent_id(id)
    end

    @minion = Minion.include_sources.find(id)
    @variants = @minion.variants
  end
end
