class OrchestrionsController < ApplicationController
  include ManualCollection
  before_action :set_collection!, only: [:index, :select]
  before_action :validate_user!, only: :select
  before_action :set_ids!, on: :select

  def index
    @category = nil if @category < 2
    @q = Orchestrion.ransack(params[:q])
    @orchestrions = @q.result.includes(:category).with_filters(cookies)
      .order(patch: :desc, order: :desc, id: :desc)
    @categories = OrchestrionCategory.with_filters(cookies).order(:order)
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
    @categories = OrchestrionCategory.all.order(:order)
    @category = params[:category].to_i
  end

  def validate_user!
    unless verified_user? && @character.verified_user?(current_user)
      redirect_to orchestrions_path
    end
  end
end
