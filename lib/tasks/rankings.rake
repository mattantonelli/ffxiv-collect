namespace :rankings do
  desc 'Cache rankings'
  task cache: :environment do
    # Rankings by server
    Character.servers.each do |server|
      characters = Character.visible.where(server: server)
      cache_rankings(characters, 'ranked_achievement_points', "rankings-achievements-#{server.downcase}")
    end

    # Rankings by data center
    Character.data_centers.each do |data_center|
      characters = Character.visible.where(data_center: data_center)
      cache_rankings(characters, 'ranked_achievement_points', "rankings-achievements-#{data_center.downcase}")
    end

    # Global rankings
    cache_rankings(Character.visible, 'ranked_achievement_points', "rankings-achievements-global")
  end
end

def cache_rankings(characters, field, key)
  rankings = characters.where("#{field} > 0")
    .order(field => :desc)
    .map.with_index(1) { |character, rank| [character.id, rank] }

  Redis.current.hmset(key, rankings.flatten) unless rankings.empty?
end
