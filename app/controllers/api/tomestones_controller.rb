class Api::TomestonesController < ApiController
  skip_before_action :set_owned

  def index
    @rewards = TomestoneReward.all.ransack(@query).result.ordered
    tomestones = @rewards.pluck(:tomestone).uniq
    @collectables = @rewards.collectables.where(tomestone: tomestones).include_related.ordered
    @items = @rewards.items.where(tomestone: tomestones).include_related.ordered
  end
end
