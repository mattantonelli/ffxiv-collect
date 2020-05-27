class TomestonesController < ApplicationController
  before_action :set_collection

  def mythology
    @title = 'Moogle Treasure Trove (Mythology)'
    @url = 'https://na.finalfantasyxiv.com/lodestone/special/mogmog-collection/201909/'
    @rewards = rewards('Mythology')
    render :index
  end

  def soldiery
    @title = 'Moogle Treasure Trove (Soldiery)'
    @url = 'https://na.finalfantasyxiv.com/lodestone/special/mogmog-collection/202001/'
    @rewards = rewards('Soldiery')
    render :index
  end

  def law
    @title = 'Moogle Treasure Trove (Law)'
    @url = 'https://na.finalfantasyxiv.com/lodestone/special/mogmog-collection/202005/'
    @rewards = rewards('Law')
    render :index
  end

  private
  def set_collection
    if @character.present?
      @collections_ids = TomestoneReward.pluck(:collectable_type).uniq.each_with_object({}) do |type, h|
        h[type] = "Character#{type}".constantize.where(character: @character).pluck("#{type.downcase}_id")
      end
    end
  end

  def rewards(tomestone)
    TomestoneReward.all.includes(collectable: { sources: [:type, :related] })
      .where(tomestone: tomestone).order(cost: :desc)
  end
end
