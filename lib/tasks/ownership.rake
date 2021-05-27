namespace :ownership do
  desc 'Cache collectable ownership'
  task cache: :environment do
    achievement_characters = Character.visible.recent.with_public_achievements
    mount_minion_characters = Character.visible.recent
    manual_collection_characters = Character.visible.recent.verified

    cache_ownership(Achievement, achievement_characters)

    [Mount, Minion].each do |model|
      cache_ownership(model, mount_minion_characters)
    end

    [Orchestrion, Emote, Barding, Hairstyle, Armoire, Spell, Relic, Fashion, Record].each do |model|
      cache_ownership(model, manual_collection_characters)
    end
  end

  def cache_ownership(model, characters)
    key = model.to_s.downcase.pluralize
    current = Redis.current.hgetall(key)
    total = characters.where("#{key}_count > 0").size

    percentages = model.joins(:characters).merge(Character.visible.recent)
      .group(:id).count.each_with_object({}) do |(id, owners), h|
      percentage = ((owners / total.to_f) * 100).to_s[0..2].sub(/\.\Z/, '').sub(/0\.0/, '0')
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
