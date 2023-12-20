module OnlineStore
  MOUNTS_URL = 'https://api.store.finalfantasyxiv.com/ffxivcatalog/api/products/?lang=en-us&currency=USD&categoryId=11&limit=999&offset=0'.freeze
  MINIONS_URL = 'https://api.store.finalfantasyxiv.com/ffxivcatalog/api/products/?lang=en-us&currency=USD&categoryId=14&limit=999&offset=0'.freeze

  extend self

  def mounts
    products = fetch_products(MOUNTS_URL, 'Mount')
    extras = { 'ceruleum balloons' => 310 }
    add_collectable_ids(products, Mount, extras)
  end

  def minions
    products = fetch_products(MINIONS_URL, 'Minion')
    extras = { 'edge' => 401, 'rydia' => 402, 'rosa' => 403}
    add_collectable_ids(products, Minion, extras)
  end

  private
  def add_collectable_ids(products, model, extras)
    premium_collectable_ids = Source.where(text: 'Online Store')
      .where(collectable_type: model.to_s)
      .pluck(:collectable_id)

    collectables = model.includes(sources: :type).where(id: premium_collectable_ids).each_with_object({}) do |collectable, h|
      # Exclude collectables with non-premium sources (e.g. events)
      if collectable.sources.map { |source| source.type.name }.all?('Premium')
        h[collectable.name_en.downcase] = collectable.id
      end
    end

    # Add custom mapping to fix naming inconsistencies
    collectables.merge!(extras)

    products.filter_map do |product|
      if id = collectables[product[:name].downcase]
        { id: id, **product }
      end
    end
  end

  def fetch_products(url, type)
    data = JSON.parse(RestClient.get(url).body, symbolize_names: true)

    data[:products].map do |product|
      # Trim extra text from the name and format the price
      {
        name: product[:name].gsub(/#{type}: /i, '').gsub(/ \((Single|Account).+/i, ''),
        price: product[:price] / 100.0
      }
    end
  end
end
