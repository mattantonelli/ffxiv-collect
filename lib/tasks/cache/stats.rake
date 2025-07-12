namespace :cache do
  desc 'Cache statistics for the FAQ page'
  task stats: :environment do
    Redis.current.set('stats-users', User.count)
    Redis.current.set('stats-characters', Character.visible.count)
    Redis.current.set('stats-achievement-characters', Character.visible.with_public_achievements.count)
  end
end
