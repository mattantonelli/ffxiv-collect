namespace :p2w do
  desc 'Cache pay-to-win data'
  task cache: :environment do
    prices = { 42 => 24.0, 68 => 12.0, 69 => 12.0, 71 => 29.99, 74 => 24.0, 84 => 29.99, 97 => 24.0,
               135 => 24.0, 138 => 24.0, 139 => 24.0, 143 => 24.0, 160 => 29.99, 171 => 24.0, 175 => 24.0,
               195 => 12.0, 206 => 24.0, 214 => 24.0, 220 => 24.0, 222 => 35.99, 233 => 42.0, 237 => 20.0,
               247 => 29.99, 269 => 24.0, 294 => 24.0 }

    characters = Character.visible.recent
    counts = CharacterMount.where(mount_id: prices.keys, character: characters).group(:mount_id).count

    data = prices.each_with_object({}) do |(id, price), h|
      h[id] = { price: price, characters: counts[id] || 0, total: price * (counts[id] || 0) }
    end

    Redis.current.set('p2w-mounts', data.to_json)
  end
end
