namespace :stats do
  desc 'Cache statistics for the FAQ page'
  task cache: :environment do
    Redis.current.set('stats-users', User.count)
    Redis.current.set('stats-characters', Character.visible.count)
    Redis.current.set('stats-active-characters', Character.visible.recent.count)
    Redis.current.set('stats-achievement-characters', Character.visible.recent.with_public_achievements.count)
  end
end
