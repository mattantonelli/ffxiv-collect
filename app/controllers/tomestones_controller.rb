class TomestonesController < ApplicationController
  before_action :set_collection

  def index
    @rewards = TomestoneReward.all.includes(collectable: { sources: [:type, :related] })
      .where(tomestone: 'Soldiery').order(cost: :desc)
  end

  def mythology
    @rewards = TomestoneReward.all.includes(collectable: { sources: [:type, :related] })
      .where(tomestone: 'Mythology').order(cost: :desc)
  end

  def soldiery
    redirect_to tomestones_path
  end

  private
  def set_collection
    if @character.present?
      @collections_ids = TomestoneReward.pluck(:collectable_type).uniq.each_with_object({}) do |type, h|
        h[type] = "Character#{type}".constantize.where(character: @character).pluck("#{type.downcase}_id")
      end
    end
  end
end
