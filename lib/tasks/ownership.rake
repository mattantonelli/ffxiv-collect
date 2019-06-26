namespace :ownership do
  desc 'Cache collectable ownership'
  task cache: :environment do
    achievement_characters = Character.visible.with_public_achievements.count.to_f
    mount_minion_characters = Character.visible.count.to_f
    manual_collection_characters = Character.visible.verified.count.to_f

    cache_ownership(Achievement, achievement_characters)

    [Mount, Minion].each do |model|
      cache_ownership(model, mount_minion_characters)
    end

    [Orchestrion, Emote, Barding, Hairstyle, Armoire].each do |model|
      cache_ownership(model, manual_collection_characters)
    end
  end

  def cache_ownership(model, characters)
    key = model.to_s.downcase.pluralize
    current = Redis.current.hgetall(key)

    percentages = model.joins(:characters).merge(Character.visible).group(:id).count.each_with_object({}) do |(id, owners), h|
      percentage = ((owners / characters) * 100).to_s[0..2].sub(/\.\Z/, '').sub(/0\.0/, '0')
      h[id] = "#{percentage}%"
    end

    updated = percentages.map do |id, percentage|
      id unless percentage == current[id.to_s]
    end

    # Touch collectables with updated ownership to expire cached data
    model.where(id: updated.compact).update_all(updated_at: Time.now)

    Redis.current.hmset(key, percentages.to_a.flatten)
  end
end
