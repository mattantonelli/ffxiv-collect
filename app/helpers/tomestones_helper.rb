module TomestonesHelper
  def reward_event_link(url)
    link_to('Moogle Treasure Trove', url.gsub('na.', "#{region}."), target: '_blank')
  end

  def reward_image(reward)
    if reward.collectable_type == 'Orchestrion'
      image_tag('orchestrion.png')
    elsif reward.collectable_type == 'Hairstyle'
      hairstyle_sample_image(reward.collectable)
    elsif reward.collectable_type == 'Mount' || reward.collectable_type == 'Minion'
      sprite(reward.collectable, "#{reward.collectable_type.downcase.pluralize}-small")
    else
      sprite(reward.collectable, reward.collectable_type.downcase)
    end
  end

  def reward_owned?(reward)
    @collections_ids&.fetch(reward.collectable_type)&.include?(reward.collectable_id)
  end

  def td_reward_owned(reward)
    owned = reward_owned?(reward)

    if reward.collectable_type == 'Mount' || reward.collectable_type == 'Minion'
      content_tag(:td, fa_icon(owned ? 'check' : 'times'), class: 'text-center', data: { value: owned ? 1 : 0 })
    else
      content_tag(:td, class: 'text-center', data: { value: owned ? 1 : 0 }) do
        check_box_tag(nil, nil, owned, class: 'own',
                      data: { path: polymorphic_path(reward.collectable, action: owned ? :remove : :add) })
      end
    end
  end

  def reward_instance_cost(reward)
    if reward.cost % 7 == 0
      cost = reward.cost / 7
      "#{cost} #{'run'.pluralize(cost)} of Castrum Meridianum"
    else
      cost = (reward.cost / 10.0).ceil
      "#{cost} #{'run'.pluralize(cost)} of The Praetorium"
    end
  end
end
