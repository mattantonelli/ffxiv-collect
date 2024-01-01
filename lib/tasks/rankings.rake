namespace :rankings do
  namespace :server do
    desc 'Cache server rankings'
    task cache: :environment do
      log('Caching server rankings')

      Character.servers.each do |server|
        characters = Character.visible.where(server: server)
        cache_rankings(characters, 'ranked_achievement_points', "rankings-achievements-#{server.downcase}")
        cache_rankings(characters, 'ranked_mounts_count', "rankings-mounts-#{server.downcase}")
        cache_rankings(characters, 'ranked_minions_count', "rankings-minions-#{server.downcase}")
      end
    end
  end

  namespace :data_center do
    desc 'Cache data center rankings'
    task cache: :environment do
      log('Caching data center rankings')

      Character.data_centers.each do |data_center|
        characters = Character.visible.where(data_center: data_center)
        cache_rankings(characters, 'ranked_achievement_points', "rankings-achievements-#{data_center.downcase}")
        cache_rankings(characters, 'ranked_mounts_count', "rankings-mounts-#{data_center.downcase}")
        cache_rankings(characters, 'ranked_minions_count', "rankings-minions-#{data_center.downcase}")
      end
    end
  end

  namespace :global do
    desc 'Cache global rankings'
    task cache: :environment do
      log('Caching global rankings')

      characters = Character.visible

      cache_rankings(characters, 'ranked_achievement_points', "rankings-achievements-global")
      cache_rankings(characters, 'ranked_mounts_count', "rankings-mounts-global")
      cache_rankings(characters, 'ranked_minions_count', "rankings-minions-global")
    end
  end
end

def cache_rankings(characters, metric, key)
  rankings = Character.leaderboards(characters: characters, metric: metric).flat_map do |ranking|
    [ranking[:character].id, ranking[:rank]]
  end

  return if rankings.empty?

  # Save the data in reasonable chunks so Redis doesn't get mad and drop our connection
  rankings.each_slice(10_000) do |slice|
    Redis.current.hmset(key, slice)
  end
end
