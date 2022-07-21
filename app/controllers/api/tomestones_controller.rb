class Api::TomestonesController < ApiController
  def index
    @rewards = TomestoneReward.all.ransack(@query).result.ordered
    tomestones = @rewards.pluck(:tomestone).uniq
    @collectables = @rewards.collectables.where(tomestone: tomestones).include_related.ordered
    @items = @rewards.items.where(tomestone: tomestones).include_related.ordered
  end
end
