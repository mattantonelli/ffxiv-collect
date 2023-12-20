namespace :p2w do
  desc 'Cache pay-to-win data'
  task cache: :environment do
    characters = Character.visible

    %w(mount minion).each do |type|
      # Fetch the latest prices from the Online Store
      products = OnlineStore.send(type.pluralize)

      # Count the # of characters that own the given collactable
      clazz = "Character#{type.capitalize}".constantize
      id_column = "#{type}_id".to_sym

      counts = clazz
        .where(id_column => products.pluck(:id), character: characters)
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
