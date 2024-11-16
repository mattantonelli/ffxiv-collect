module TomestonesHelper
  def reward_market_link(reward)
    if reward.collectable.tradeable?
      link_to(fa_icon('dollar-sign'), universalis_url(reward.collectable.id), target: '_blank')
    end
  end
end
