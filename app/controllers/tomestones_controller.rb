class TomestonesController < ApplicationController
  def index
    @rewards = TomestoneReward.all.includes(collectable: { sources: [:type, :related] }).order(cost: :desc)

    if @character.present?
      @collections_ids = TomestoneReward.pluck(:collectable_type).uniq.each_with_object({}) do |type, h|
        h[type] = "Character#{type}".constantize.where(character: @character).pluck("#{type.downcase}_id")
      end
    end
  end
end
