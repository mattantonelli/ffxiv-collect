class OrchestrionsController < ApplicationController
  def index
    @orchestrions = Orchestrion.includes(:category).order(patch: :desc, order: :desc, id: :desc).all
    @categories = OrchestrionCategory.all.order(:id)

    @category = params[:category].to_i
    @category = nil if @category < 2
  end

  def show
    @orchestrion = Orchestrion.find(params[:id])
  end
end
