class MinionsController < ApplicationController
  def index
    @minions = Minion.summonable.includes(:behavior, :race, :skill_type).order(patch: :desc)

    if user_signed_in?
      @minion_ids = current_user.character.minion_ids
    end
  end

  def show
    @minion = Minion.find(params[:id])

    if @minion.id == 67 || @minion.id == 71
      @variants = Minion.where(id: (@minion.id + 1)..(@minion.id + 3))
    end
  end
end
