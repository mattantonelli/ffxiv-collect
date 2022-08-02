module TomestonesHelper
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

  def tomestone_name(tomestone, locale = :en)
    name = tomestone["name_#{locale}"]

    case locale
    when :fr
      name.split(' ')[-2]
    when :ja
      name.split(':').last
    else
      name.split(' ').last
    end
  end
end
