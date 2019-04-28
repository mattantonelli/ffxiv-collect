class MinionsController < ApplicationController
  def index
    @minions = Minion.summonable.includes(:behavior, :race, :skill_type).order(patch: :desc)
  end

  def show
    @minion = Minion.find(params[:id])

    if @minion.id == 67 || @minion.id == 71
      @variants = Minion.where(id: (@minion.id + 1)..(@minion.id + 3))
    end
  end
end
