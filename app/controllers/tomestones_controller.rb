class TomestonesController < ApplicationController
  before_action :set_collection

  def mythology
    @title = 'Moogle Treasure Trove (Mythology)'
    @url = 'https://na.finalfantasyxiv.com/lodestone/special/mogmog-collection/201909/'
    @collectables = collectables('Mythology')
    render :index
  end

  def soldiery
    @title = 'Moogle Treasure Trove (Soldiery)'
    @url = 'https://na.finalfantasyxiv.com/lodestone/special/mogmog-collection/202001/'
    @collectables = collectables('Soldiery')
    render :index
  end

  def law
    @title = 'Moogle Treasure Trove (Law)'
    @url = 'https://na.finalfantasyxiv.com/lodestone/special/mogmog-collection/202005/'
    @collectables = collectables('Law')
    render :index
  end

  def esoterics
    @title = 'Moogle Treasure Trove (Esoterics)'
    @url = 'https://na.finalfantasyxiv.com/lodestone/special/mogmog-collection/202103/2ozonfi9xh'
    @collectables = collectables('Esoterics')
    @items = items('Esoterics')
    render :index
  end

  private
  def set_collection
    if @character.present?
      @collections_ids = TomestoneReward.collectable.pluck(:collectable_type).uniq.each_with_object({}) do |type, h|
        h[type] = "Character#{type}".constantize.where(character: @character).pluck("#{type.downcase}_id")
      end
    end
  end

  def collectables(tomestone)
    TomestoneReward.collectable.includes(collectable: { sources: [:type, :related] })
      .where(tomestone: tomestone).order(cost: :desc)
  end

  def items(tomestone)
    TomestoneReward.items.includes(:collectable).where(tomestone: tomestone).order(cost: :desc)
  end
end
