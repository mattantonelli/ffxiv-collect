class TomestonesController < ApplicationController
  include Collection
  include TomestonesHelper

  skip_before_action :set_owned!, :set_ids!, :set_dates!

  def index
    if @character.present?
      @collections_ids = TomestoneReward.collectable.pluck(:collectable_type).uniq.each_with_object({}) do |type, h|
        h[type] = "Character#{type}".constantize.where(character: @character).pluck("#{type.downcase}_id")
      end
    end

    @tomestones = TomestoneReward.order(:created_at).pluck(:tomestone).uniq

    if params[:action] == 'index'
      @tomestone = @tomestones.last
    else
      @tomestone = params[:id].capitalize
    end

    @title = "#{t('tomestones.title')}: #{tomestone_name(@tomestone)}"
    @collectables = collectables(@tomestone)
    @items = items(@tomestone)
  end

  # Leverage ID param to dynamically route to tomestone rewards by name
  def show
    index
    render :index
  end

  private
  def collectables(tomestone)
    TomestoneReward.collectable.includes(collectable: { sources: [:type, :related] })
      .where(tomestone: tomestone).order(cost: :desc)
  end

  def items(tomestone)
    TomestoneReward.items.includes(:collectable).where(tomestone: tomestone).order(cost: :desc)
  end
end
