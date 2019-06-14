class MinionsController < ApplicationController
  include Collection

  def index
    @q = Minion.summonable.ransack(params[:q])
    @minions = @q.result.includes(:behavior, :race, :skill_type)
      .include_sources.with_filters(cookies).order(patch: :desc, id: :desc).distinct
    @types = source_types(:minion)
    @minion_ids = @character&.minion_ids || []
  end

  def show
    @minion = Minion.include_sources.find(params[:id])
    @variants = @minion.variants
  end
end
