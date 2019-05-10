ARMOIRE_COLUMNS = %w(ID Order CategoryTargetID Item.ID Item.Icon Item.Name_*).freeze

namespace :armoires do
  desc 'Create the armoire items'
  task create: :environment do
    puts 'Creating armoire items'

    XIVAPI_CLIENT.content(name: 'CabinetCategory', columns: %w(ID Category.Text_* MenuOrder)).each do |category|
      next unless category.menu_order > 0
      data = { id: category.id, order: category.menu_order }

      %w(en de fr ja).each do |locale|
        data["name_#{locale}"] = category.category["text_#{locale}"]
      end

      ArmoireCategory.find_or_create_by!(data)
    end

    count = Armoire.count
    armoires = XIVAPI_CLIENT.content(name: 'Cabinet', columns: ARMOIRE_COLUMNS, limit: 1000).map do |armoire|
      next if armoire.order == 0 || armoire.item.name_en.empty?
      data = { id: armoire.id + 1, category_id: armoire.category_target_id, order: armoire.order }

      %w(en de fr ja).each do |locale|
        data["name_#{locale}"] = sanitize_name(armoire.item["name_#{locale}"])
      end

      download_image(data[:id], armoire.item.icon, 'armoires')

      if existing = Armoire.find_by(id: data[:id])
        existing.update!(data) if updated?(existing, data.symbolize_keys)
        nil
      else
        Armoire.create!(data)
        data.merge(item_id: armoire.item.id)
      end
    end

    # Add patch data to newly created Armoire entries
    item_ids = armoires.compact!.pluck(:item_id)
    if item_ids.present?
      [*XIVAPI_CLIENT.content(name: 'Item', ids: item_ids, columns: %w(ID GamePatch.Version), limit: 1000)].each do |item|
        id = armoires.find { |armoire| armoire[:item_id] == item.id }[:id]
        Armoire.find(id).update!(patch: item.game_patch.version)
      end
    end

    create_spritesheet(Armoire, 'armoires', 'armoires.png', 40, 40)

    puts "Created #{Armoire.count - count} new armoire items"
  end
end
