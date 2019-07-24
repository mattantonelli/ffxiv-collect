BARDING_COLUMNS = %w(ID Name_* IconBody IconHead).freeze
BARDING_ITEM_COLUMNS = %w(ItemAction.Data0 Name_*).freeze

namespace :bardings do
  desc 'Create the bardings'
  task create: :environment do
    puts 'Creating bardings'

    count = Barding.count

    names = XIVAPI_CLIENT.search(indexes: 'Item', columns: BARDING_ITEM_COLUMNS, filters: 'ItemAction.Type=1013', limit: 999)
      .each_with_object({}) do |item, h|
      h[item.item_action.data0] = item.to_h.slice(:name_en, :name_de, :name_fr, :name_ja)
    end

    XIVAPI_CLIENT.content(name: 'BuddyEquip', columns: BARDING_COLUMNS, limit: 1000).each do |barding|
      next unless barding.name_en.present?

      data = barding.to_h.slice(:id, :name_en, :name_de, :name_fr, :name_ja)

      # If the barding has an unlock item with names, use those instead
      barding_names = names[barding.id]
      data.merge!(barding_names) if barding_names.present?

      %w(en de fr ja).each do |locale|
        data["name_#{locale}"] = sanitize_name(data["name_#{locale}".to_sym])
      end

      image_url = barding.icon_body.present? ? barding.icon_body : barding.icon_head
      download_image(barding.id, image_url, 'bardings')

      if existing = Barding.find_by(id: barding.id)
        data = without_custom(data)
        existing.update!(data) if updated?(existing, data.symbolize_keys)
      else
        Barding.create!(data)
      end
    end

    create_spritesheet('bardings')

    puts "Created #{Barding.count - count} new bardings"
  end
end
