class MinionsController < ApplicationController
  include Collection
  before_action :set_minions, except: :show

  def index
    @minions = @minions.with_filters(cookies).order(patch: :desc, order: :desc)
  end

  def verminion
    @minions = @minions.order(order: :asc)
  end

  def show
    @minion = Minion.include_sources.find(params[:id])
    @variants = @minion.variants
  end

  private
  def set_minions
    if params[:strength].present?
      params[:q].merge!("#{params[:strength]}_true" => 1)
    end

    @q = Minion.summonable.ransack(params[:q])
    @minions = @q.result.includes(:behavior, :race, :skill_type)
      .include_sources.distinct
    @types = source_types(:minion)
    @minion_ids = @character&.minion_ids || []
  end
end
