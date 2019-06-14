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
    model.joins(:characters).merge(Character.visible).group(:id).count.each do |id, owners|
      percentage = ((owners / characters) * 100).to_s[0..2].sub(/\.\Z/, '').sub(/0\.0/, '0')
      Redis.current.hset(model.to_s.downcase.pluralize, id, "#{percentage}%")
    end
  end
end
