class MinionsController < ApplicationController
  include Collection

  def index
    @q = Minion.summonable.ransack(params[:q])
    @minions = @q.result.includes(:behavior, :race, :skill_type, sources: :type).order(patch: :desc).distinct
    @types = source_types(:minion)
    @minion_ids = @character&.minion_ids || []
  end

  def show
    @minion = Minion.find(params[:id])

    if @minion.id == 67 || @minion.id == 71
      @variants = Minion.where(id: (@minion.id + 1)..(@minion.id + 3))
    end
  end
end
