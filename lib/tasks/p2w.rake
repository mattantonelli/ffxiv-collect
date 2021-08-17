namespace :p2w do
  desc 'Cache pay-to-win data'
  task cache: :environment do
    prices = { 247 => 29.99, 233 => 42.00, 222 => 35.99, 220 => 24.00, 214 => 24.00, 206 => 24.00,
               195 => 12.00, 175 => 24.00, 171 => 24.00, 71 => 29.99, 160 => 29.99, 143 => 24.00,
               135 => 24.00, 139 => 24.00, 138 => 24.00, 97 => 24.00, 84 => 29.99, 74 => 24.00,
               69 => 12.00, 68 => 12.00, 42 => 24.00 }
    characters = Character.visible.recent
    counts = CharacterMount.where(mount_id: prices.keys, character: characters).group(:mount_id).count

    data = prices.each_with_object({}) do |(id, price), h|
      h[id] = { price: price, characters: counts[id] || 0, total: price * (counts[id] || 0) }
    end

    Redis.current.set('p2w-mounts', data.to_json)
  end
end
