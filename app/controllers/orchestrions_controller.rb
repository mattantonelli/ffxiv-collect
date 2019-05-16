class OrchestrionsController < ApplicationController
  include ManualCollection
  before_action :set_collection!, only: [:index, :select]
  before_action :validate_user!, only: :select

  def index
    @category = nil if @category < 2
    @q = Orchestrion.ransack(params[:q])
    @orchestrions = @q.result.includes(:category).order(patch: :desc, order: :desc, id: :desc).distinct
  end

  def select
    @orchestrions = Orchestrion.includes(:category).order(order: :asc, id: :asc).all
    @category = 2 if @category < 2
  end

  def show
    @orchestrion = Orchestrion.find(params[:id])
  end

  def add
    add_collectable(@character.orchestrions, Orchestrion.find(params[:id]))
  end

  def remove
    remove_collectable(@character.orchestrions, params[:id])
  end

  private
  def set_collection!
    @orchestrion_ids = @character&.orchestrion_ids || []
    @categories = OrchestrionCategory.all.order(:id)
    @category = params[:category].to_i
  end

  def validate_user!
    unless verified_user? && @character.verified_user?(current_user)
      flash[:alert] = 'You must be signed in and verified in order to manage your orchestrion rolls.'
      redirect_to root_path
    end
  end
end
