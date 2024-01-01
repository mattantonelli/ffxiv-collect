namespace :p2w do
  desc 'Cache pay-to-win data'
  task cache: :environment do
    %w(mount minion).each do |type|
      log("Caching P2W #{type} data")

      # Fetch the latest prices from the Online Store
      products = OnlineStore.send(type.pluralize)

      # Count the # of characters that own the given collactable
      clazz = "Character#{type.capitalize}".constantize
      id_column = "#{type}_id".to_sym

      counts = clazz.joins(:character)
        .where('characters.public IS TRUE')
        .where(id_column => products.pluck(:id))
        .group(id_column)
        .count

      # Aggregate the data
      data = products.each_with_object({}) do |product, h|
        id, price = product.values_at(:id, :price)

        h[id] =
          {
            price: price,
            characters: counts[id] || 0,
            total: price * (counts[id] || 0)
          }
      end

      # Save the result to Redis
      Redis.current.set("p2w-#{type.pluralize}", data.to_json)
    end
  end
end
